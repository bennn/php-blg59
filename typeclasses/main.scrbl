#lang scribble/manual
@require[racket/include]
@require[scribble/eval]

@title[#:tag "top"]{@bold{Proposal: Parametric Overloading}}
@author[@hyperlink["https://github.com/bennn"]{Ben Greenman}]

Parametric overloading, as defined by @hyperlink["http://download.springer.com/static/pdf/509/chp%253A10.1007%252F3-540-19027-9_9.pdf?auth66=1423013160_aa6610ee11f095e859bf06ce5251f706&ext=.pdf"]{Kaes}, allows a single identifier to denote several functions, each of whose types are instances of a single type expression.
A classic example is the @tt{equal?} function from the @tt{racket} language, which we will use repeatedly:
@interaction[
(equal? 2 2)

(equal? "hello" "world")
]

An accurate type for @tt{equal?} should include at least the cases @tt{(-> Integer Integer Integer)} and @tt{(-> String String String)}.
This document outlines one way to achieve this behavior.

@section{Background}
Before Kaes introduced parametric overloading in 1988, the two best-known techniques for generalizing functions were @emph{parametric polymorphism} and @emph{ad-hoc polymorphism}.
We review them to put this idea in context.

@subsection{Parametric Polymorphism}
A parametrically polymorphic function applies a uniform algorithm no matter the exact type of its arguments.
For example, a parametrically polymorphic version of @tt{equal?} might be the following:
@codeblock{
(: equal? (All (A) (-> A A Boolean)))
(define (equal? a b)
  #f)
}
While not very useful, we see that it acts uniformly on arguments of any type @tt{A}.
More useful is the parametric @tt{length} function, which counts the number of elements in a list, no matter the type of these elements.
@codeblock{
(: length? (All (A) (-> (Listof A) Integer)))
(define (length xs)
  (cond [(empty? xs) 0]
        [else (add1 (length (cdr xs)))]))
}

@subsection{Ad-Hoc Polymorphism}
In contrast, ad-hoc polymorphism selects an algorithm based on the type of its argument.
For example, this ad-hoc polymorphic version of @tt{equal?} is similar to the standard @tt{typed/racket} implementation:
@codeblock{
(: equal? (-> Any Any Boolean))
(define (equal? a b)
  (cond [(and (integer? a)
              (integer? b)) (= a b)]
        [(and (string?  a)
              (string?  b)) (string=? a b)]
        [(and (list?    a)
              (list?    b)) (for/and ([a* a] [b* b]) (equal? a* b*))]
        [else #f]))
}

@subsection{Parametric Overloading}
Parametric polymorphism gives useful type signatures, but works at a high level of abstractions.
Ad-hoc polymorphism breaks abstraction barriers and may render type signatures useless, but allows for versatile and specific programs.
Parametric overloading seeks to unite these concerns for a particular class of ad-hoc functions.

This class of functions is any set with a uniform argument pattern.
If we can give meaningful definitions of one pattern instantiated at different types, then we have a candidate for parametric overloading.

As an example, we present a hypothetical, extensible version of @tt{equal?}:
@codeblock{
(define-signature equal? (All (A) (-> A A Boolean)))

(: equal? (-> Integer Integer Boolean))
(define/overload (equal? n1 n2)
  (= n1 n2))

(: equal? (-> String String Boolean))
(define/overload (equal? s1 s2)
  (string=? s1 s2))

(: equal? (All/equal? (A) (-> (Listof A) (Listof A) Boolean)))
(define/overload (equal? xs ys)
  (for/and ([x xs] [y ys])
    (equal? x y)))

(define-struct Foobar ([foo : Integer] [bar : String]))

(: equal? (-> Foobar Foobar Boolean))
(define/overload (equal? f1 f2)
  (and (equal? (foobar-foo f1) (foobar-foo f2))
       (equal? (foobar-bar f1) (foobar-bar f2))))
}

@section{Related Work}
The above design may look familiar.
Here we discuss relatives and alternatives.

@subsection{@tt{case-lambda}}
Typed Racket's @tt{case-lambda} and @tt{case->} allow behavior very similar to parametric overloading.
We could define @tt{equal?} by cases as follows:
@codeblock{
(: equal? (All (A) (case->
           [-> Integer    Integer    Boolean]
           [-> String     String     Boolean]
           [-> (Listof A) (Listof A) Boolean]
           [-> Any        Any        Boolean])))
(define (equal? a b)
  (cond [(and (integer? a)
              (integer? b)) (= a b)]
        [(and (string?  a)
              (string?  b)) (string=? a b)]
        [(and (list?    a)
              (list?    b)) (for/and ([a* a] [b* b]) (equal? a* b*))]
        [else #f]))
}

However, this pattern has a few shortcomings:
@itemlist[
  @item{Once defined, @tt{equal?} is not extensible.
        If we later want to compare a @tt{Symbol}, we need to edit or replace the @tt{equal?} function.}
  @item{We cannot restrict the exact type of @tt{A}, so we need to include the catch-all pattern or nested assertions for @tt{List} equality to work properly.
        This also means we cannot rule out failure cases at compile-time, so we lose one benefit of static typing.}
]
That said, our design is both motivated and encouraged by the existing @tt{case->} construct.


@subsection{Typeclasses}
Haskell implements parametric overloading through typeclasses.
Although we have yet to discuss our proposed implementation to parametric overloading, we summarize the Haskell implementation here and hope meaningful differences become apparent.
For a more complete treatment, see the tutorial by @hyperlink["http://okmij.org/ftp/Computation/typeclass.html"]{Kiselyov}.

A typeclass, like an interface or module signature, defines a name and a group of functions.
(Note: class declarations may also contain implementations.)
@codeblock{
class Eq a where
  (==) :: a -> a -> bool
  (/=) :: a -> a -> bool
}

This new name, @tt{Eq a}, can now be instantiated for specific types and used as a constraint in function signatures.
The following is an example instantiation for numbers:
@codeblock{
instance Eq Num where
  m == n = integerEq m n
  m /= n = not (m == n)
}

And here is a function constrained by the name @tt{Eq a}.
@codeblock{
member :: Eq a => a -> [a] -> bool
member a []     = False
member a (b:bs) = (a == b) || (member a bs)
}

Here's how it works:
@itemlist[
  @item{The class declaration creates a dictionary signature.
        The instance declaration(s) create dictionaries matching that signature.}
  @item{As the programmer adds more @tt{instance} declarations, the environment saves them.}
  @item{Functions like @tt{member} implicitly take an extra argument.
        This argument is the dictionary instance matching the concrete type for @tt{a}.}
  @item{The compiler determines which instance to pass each function, and the function accesses the dictionary fields to use the typeclass functions.}
]

So we see, typeclasses are one way to implement parametric overloading.
They have little cost on the language user and allow the definition of multiple overloaded functions at once.


@section{Proposed Implementation}
I suggest that we follow the approach outlined by Kaes and implement an "extensible version of @tt{case-lambda}".
@itemlist[
  @item{Add a construct @tt{define-signature} for declaring overload-able signatures.}
  @item{Add a construct @tt{define/overload} for implementing a signature.
        Also need to check that the implementing type matches the defined pattern.}
  @item{Track a mapping from @tt{define-signature} identifiers to their implementations, indexed by type signature.}
  @item{Track the set of type variables used in each instantiation.
        The construct @tt{All/id} will restrict type variable instantiations to be members of the set bound to the signature @tt{id}.}
  @item{Macro-expand at application sites with the correct implementation.
        Choose implementations by first searching for an exact type match, then relaxing to subtypes.
        In the case of @tt{equal?}, above, we need only know the type of one argument to pick out the right implementation.
        Alternatively, we could demand explicit instantiations via @tt{inst} in a first draft.}
]

Additionally, I think these features would be useful:
@itemlist[
  @item{Aliasing for @tt{define-signature} identifiers.
        If @tt{equal?} is already defined with members, @tt{define-signature eq2 equal?} should copy the known implementations for @tt{equal?} and henceforth accept its own, independent implementations.
        In other words, an alias adds a new, pre-populated map entry.}
  @item{Allow multiple parameters in @tt{define-signature} declarations (I am not sure if this is difficult for this approach, but I know the typeclasses community got at least a @hyperlink["http://journals.cambridge.org/action/displayAbstract?fromPage=online&aid=100087&fileId=S0956796801004233"]{paper} out of their implementation).}
  @item{Allow @tt{case->} types with varying arity for a @tt{define-signature}.
        I think this is an opportunity to out-do the Haskell crowd, but need to double-check (and, we still don't have their type families or default implementations).}
]

@section{Next Steps}

@itemlist[
  @item{Share with Racket group}
  @item{Make sure there's nothing in Typed Racket's implementation to complicate things.
        For instance, how are type variables implemented?
        How does @tt{case->} select the right case---does order matter?}
  @item{Prototype.}
]
