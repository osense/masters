\documentclass[
  digital, %% This option enables the default options for the
           %% digital version of a document. Replace with `printed`
           %% to enable the default options for the printed version
           %% of a document.
  twoside, %% This option enables double-sided typesetting. Use at
           %% least 120 g/m² paper to prevent show-through. Replace
           %% with `oneside` to use one-sided typesetting; use only
           %% if you don’t have access to a double-sided printer,
           %% or if one-sided typesetting is a formal requirement
           %% at your faculty.
  notable,   %% This option causes the coloring of tables. Replace
           %% with `notable` to restore plain LaTeX tables.
  nolof    %% This option prints the List of Figures. Replace with
           %% `nolof` to hide the List of Figures.
  %% More options are listed in the user guide at
  %% <http://mirrors.ctan.org/macros/latex/contrib/fithesis/guide/mu/fi.pdf>.
]{fithesis3}

%%\usepackage{fontspec}
%%\usepackage{yfonts}
%%\usepackage{unicode-math}
%%\usepackage{xunicode}
\usepackage[main=english]{babel} 

\thesissetup{
    date          = \the\year/\the\month/\the\day,
    university    = mu,
    faculty       = fi,
    type          = mgr,
    author        = {Bc. Adam Krupička},
    gender        = m,
    advisor       = {RNDr. Martin Jonáš},
    title         = {Coinductive Formalization of SECD Machine in Agda},
    TeXtitle      = {Coinductive Formalization of SECD Machine in Agda},
    keywords      = {SECD Agda formalization coinduction},
    TeXkeywords   = {SECD Agda formalization coinduction},
    abstract      = {This is the abstract of my thesis, which can

                     span multiple paragraphs.},
    thanks        = {These are the acknowledgements for my thesis, which can

                     span multiple paragraphs.},
    bib           = bibliography.bib
}

%% \usepackage{makeidx}      %% The `makeidx` package contains
%%\makeindex                %% helper commands for index typesetting.
%% These additional packages are used within the document:
%%\usepackage{amsmath}  %% Mathematics
%%\usepackage{mathtools}  %% Mathematics
%%\usepackage{amsthm}
%%\usepackage{amsfonts}
\usepackage[backend=biber]{biblatex}
\usepackage{amssymb}
\usepackage{booktabs}
\usepackage{url}      %% Hyperlinks

%%\theoremstyle{definition}
%%\newtheorem{theorem}{Theorem}
%%\newtheorem{definition}{Definition}
%%\newtheorem{notation}{Notation}


\usepackage{agda}
\usepackage{newunicodechar}
\newunicodechar{λ}{\ensuremath{\mathnormal\lambda}}
\newunicodechar{ƛ}{\ensuremath{\mathnormal\lambda}}
\newunicodechar{ι}{\ensuremath{\mathnormal\iota}}
\newunicodechar{ℕ}{\ensuremath{\mathnormal\mathbb{N}}}
\newunicodechar{ℤ}{\ensuremath{\mathnormal\mathbb{Z}}}
\newunicodechar{↝}{\ensuremath{\mathnormal\leadsto}}
\newunicodechar{ᵈ}{\ensuremath{^d}}
\newunicodechar{ᶜ}{\ensuremath{^c}}
\newunicodechar{★}{\ensuremath{\mathnormal\star}}
\newcommand{\A}{\AgdaArgument}
\newcommand{\D}{\AgdaDatatype}
\newcommand{\I}{\AgdaInductiveConstructor}
\newcommand{\F}{\AgdaFunction}

\makeatletter
\renewcommand{\@chapapp}{}% Not necessary...
\newenvironment{chapquote}[2][2em]
  {\setlength{\@tempdima}{#1}%
   \def\chapquote@author{#2}%
   \parshape 1 \@tempdima \dimexpr\textwidth-2\@tempdima\relax%
   \itshape}
  {\par\normalfont\hfill---\ \chapquote@author\hspace*{\@tempdima}\par\bigskip}
\makeatother

\begin{document}
\chapter{Introduction}

\chapter{Intuitionistic logic}
\begin{chapquote}{R. Feynman}
  What I cannot create, I do not understand.
\end{chapquote}

\chapter{Agda}
\begin{chapquote}{From the topic of the official Agda IRC channel}
  Agda: is it a dependently-typed programming language? Is it a proof-assistant
  based on intuitionistic type theory?

  \verb| ¯\(°_0)/¯| Dunno, lol.
\end{chapquote}
Agda\parencite{norell2007towards} is a
\section{Basics}
In this section, we present a few simple types in order to get accustomed to the
syntax of Agda by way of example.
\subsection{Trivial Types}
The simples type is a type which is trivially inhabited by a single value. This
type is often refered to as \textit{Top} or \textit{Unit}. In Agda,
\begin{code}
data ⊤ : Set where
  ⋅ : ⊤
\end{code}
declares the new data type \AgdaDatatype{⊤} which is itself of type
\AgdaPrimitiveType{Set}\footnote{For the reader familiar with the Haskell type
  system, the Agda type Set is akin to the Haskell kind \textit{Star}.}. The
second line declared a constructor for this type, here called simply
\AgdaInductiveConstructor{⋅}, which constructs a value of type
\AgdaDatatype{⊤}\footnote{Again for the Haskell-able, note how the syntax here
  resembles that of Haskell with the extension \texttt{GADTs}.}.

The dual of \AgdaDatatype{⊤} is the trivially uninhabited type, often called
\textit{Bottom} or \textit{Empty}. Complete definition in Agda follows.
\begin{code}
data ⊥ : Set where
\end{code}
Note how there are no constructors declared for this type, therefore it is
clearly uninhabited.
\subsection{Booleans}
A step-up from the trivially inhabited type \AgdaDatatype{⊤}, the type of
booleans is made up of two distinct values.
\begin{code}
data Bool : Set where
  tt ff : Bool
\end{code}
Since both constructors have the same type signature, we took advantage of a
feature in Agda that allows us to declare such constructors on one line,
together with the shared type.

We can also declare our first function now, one that will perform negation of
Boolean values.
\begin{code}
¬_ : Bool → Bool
¬ tt = ff
¬ ff = tt
\end{code}
Here we utilized pattern matching to split on the argument and
flipped one into the other. Note the underscore \texttt{\_} in the name declaration of this
function: it symbolizes where the argument is to be
expected. Agda has a strong support for mixfix operators and we will see more
examples of this later.

Another function we can define is the conjunction of two boolean values, using a
similar approach.
\begin{code}
_∧_ : Bool → Bool → Bool
tt ∧ b = b
ff ∧ b = ff
\end{code}
\subsection{Products}
To define the product type, it is customary to use a record. This will give us
implicit projection functions from the type.
\begin{code}
record _×_ (A : Set) (B : Set) : Set where
  constructor _,_
  field
    proj₁ : A
    proj₂ : B
infixr 4 _,_
\end{code}
Here we declared a new record type, parametrized by two other types,
\AgdaArgument{A} and \AgdaArgument{B}. These are the types of the values stored
in the pair, which we construct with the operator
\AgdaInductiveConstructor{\_,\_}. We also declare the fixity of this operator to
be right-associative.
\subsection{Natural numbers}
To see a more interesting example of a type, let us consider the type of natural numbers. These can be implemented using Peano encoding, as shown below.
\begin{code}[hide]
module Hidden where
\end{code}
\begin{code}
  data ℕ : Set where
    zero : ℕ
    suc  : ℕ → ℕ
\end{code}
Here we have a nullary constructor for the value zero, and then a unary
constructor which corresponds to the successor function. As an example, consider the
number 3, which would be encoded as~\AgdaInductiveConstructor{suc(suc(suc\
  zero))}.

As an example of a function on the naturals, let us define the addition function.
\begin{code}
  _+_ : ℕ → ℕ → ℕ
  zero + b  = b
  suc a + b = suc (a + b)
\end{code}
We proceed by induction on the left argument: if that number is zero, the result
is simply the right argument. If the left argument is a successor to some number
\AgdaArgument{a}, we inductively perform addition of \AgdaArgument{a} to
\AgdaArgument{b}, and then apply the successor function.
\section{Propositional Equality}
In this section, we will take a short look at one of the main features of
intuitionistic type theory, namely, the identity type. This type allows us to
state the proposition that two values of some data type are \textit{equal}. The
concept of \textit{equal} here is that both of the values are convertible to the
same value through reductions. This is the concept of propositional equality.
Compare this with definitional equality, which only allows us to express
when two values have the same syntactic representation. For example,
definitionaly it holds that $2=2$, however, $1+1=2$ only holds propositionaly,
because a reduction is required on the left-hand side.

We can define propositional equality in Agda as follows.
\begin{code}
  data _≡_ {A : Set} : A → A → Set where
    refl : {x : A} → x ≡ x
\end{code}
\begin{code}[hide]
open import Relation.Binary.PropositionalEquality using (_≡_; refl)
open import Data.Nat using (ℕ; zero; suc) renaming (_≟_ to _≟ℕ_)
\end{code}
The equality type is polymorhic in some other underlying type, \AgdaArgument{A}.
The only way we have to construct values of this type is by the constructor
\AgdaInductiveConstructor{refl}, which says that each value is propositionaly
equal to itself. Symmetry and transitivity of \AgdaDatatype{\_≡\_} are theorems
in Agda.
\begin{code}
sym : {A : Set} {a b : A} → a ≡ b → b ≡ a
sym refl = refl

trans : {A : Set} {a b c : A} → a ≡ b → b ≡ c → a ≡ c
trans refl refl = refl
\end{code}
By case splitting on the arguments we force Agda to unify the variables \A{a},
\A{b}, and \A{c}. Afterwards, we can construct the required proof with the
\I{refl} constructor. This is a feature of the underlying type theory of Agda.

Finally, let us see the promised proof of $1+1=2$,
\begin{code}[hide]
module Hidden2 where
  open import Data.Nat using (_+_)
\end{code}
\begin{code}
  1+1≡2 : 1 + 1 ≡ 2
  1+1≡2 = refl
\end{code}
The proof is trivial, as $1+1$ reduces directly to two. A more interesting proof
would be that of associativity of addition,
\begin{code}
  +-assoc : ∀ {a b c} → a + (b + c) ≡ (a + b) + c
  +-assoc {zero}  = refl
  +-assoc {suc a} = let a+[b+c]≡[a+b]+c = +-assoc {a}
                      in ≡-cong suc a+[b+c]≡[a+b]+c
    where ≡-cong : {A B : Set} {a b : A} → (f : A → B) → a ≡ b → f a ≡ f b
          ≡-cong f refl = refl
\end{code}
\section{Decidable Equality}
\begin{code}
open import Relation.Binary.Core using (Decidable)
open import Relation.Nullary using (Dec; yes; no)

_≟B_ : Decidable {A = Bool} _≡_
tt  ≟B tt = yes refl
ff ≟B ff  = yes refl
tt  ≟B ff = no λ()
ff ≟B tt  = no λ()

⌊_⌋ : {A : Set} {a b : A} → Dec (a ≡ b) → Bool
⌊ yes p ⌋ = tt
⌊ no ¬p ⌋ = ff
\end{code}
\section{Formalizing Type Systems}
In what follows, we will take a look at how we can use Agda to formalize
deductive systems. We will take the simplest example there is, the Simply Typed
λ Calculus. Some surface-level knowledge of this calculus is assumed.
\subsection{De Bruijn Indices}
Firstly, we shall need some machinery to make our lives easier. We could use
string literals as variable names in our system, however this would lead to
certain difficulties further on. Instead, we shall use the concept commonly
referred to as De Bruijn indices\parencite{de1972lambda}. These replace variable
names with natural numbers, where each number $n$ refers to the variable bound
by the binder $n$ positions above the current scope in the syntactical tree. Some
examples of this naming scheme are shown in Figure \ref{debruijn}.
\begin{figure}[h]
  \centering
  \begin{tabular}{ l l }
    \multicolumn{1}{c}{Literal syntax} & \multicolumn{1}{c}{De Bruijn syntax} \\
    \midrule
    \verb|λx.x| & \verb|λ 0| \\
    \verb|λx.λy.x| & \verb|λλ 1| \\
    \verb|λx.λy.λz.x z (y z)| & \verb|λλλ 2 0 (1 0)| \\
    \verb|λf.(λx.f(x x)) (λx.f(x x))| & \verb|λ(λ 1 (0 0)) (λ 1 (0 0))| \\
  \end{tabular}
  \caption{Examples of λ terms using standard naming scheme on the left and
    using De Bruijn indices on the right.}
  \label{debruijn}
\end{figure}
The immediately apparent advantage of using De Bruijn indices is that
α-equivalence of λ terms becomes trivially decidable by way of purely syntactic
equality. Other advantages include easier formalization.
\subsubsection{Implementation}
To implement De Bruijn indices in Agda, we will express what it means for a
variable to be present in a context. We shall assume that a context is a list of
types, as this is how contexts will be defined in the next subsection. We will
express list membership as a new data type,
\begin{code}[hide]
open import Data.List using (List; []; [_]; _∷_; null; map; all; length)
\end{code}
\begin{code}
data _∈_ {A : Set} : A → List A → Set where
  here : ∀ {x xs} → x ∈ (x ∷ xs)
  there : ∀ {x a xs} → x ∈ xs → x ∈ (a ∷ xs)
infix 10 _∈_
\end{code}
The first constructor says that an element is present in a list if that element
is the head of the list. The second constructor says that if we already know
that our element \A{x} is in a list, we can extend the list with another element
and \A{x} will still be present in the new list.

Now we can also define a function which, given a proof that an element is in a
list, returns the aforementioned element.
\begin{code}
lookup : ∀ {A x xs} → x ∈ xs → A
lookup {x = x} here = x
lookup (there w)    = lookup w
\end{code}
We will also define shorthands to construct often-used elements of \D{\_∈\_} for
use in examples later on.
\begin{code}
𝟎 : ∀ {A} {x : A} {xs : List A} → x ∈ (x ∷ xs)
𝟎 = here

𝟏 : ∀ {A} {x y : A} {xs : List A} → x ∈ (y ∷ x ∷ xs)
𝟏 = there here

𝟐 : ∀ {A} {x y z : A} {xs : List A} → x ∈ (z ∷ y ∷ x ∷ xs)
𝟐 = there (there here)
\end{code}
\subsection{Example: Simply Typed λ Calculus}
In this subsection we will, in preparation of the main matter of this thesis,
introduce the way typed deductive systems can be formalized in Agda. As
promised, we will formalize the Simply Typed λ Calculus.
\subsubsection{Syntax}
First, we define the types in our system.
\begin{code}[hide]
module Hidden3 where
\end{code}
\begin{code}
  data ★ : Set where
    ι   : ★
    _⇒_ : ★ → ★ → ★
  infixr 20 _⇒_
\end{code}
Here we defined some atomic type \I{ι} and a binary type constructor for
function types. We proceed by defining context as a list of types.
\begin{code}
  Context : Set
  Context = List ★
\end{code}
Now we are finally able to define the deductive rules that make up the calculus,
using De Bruijn indices as explained above.
\begin{code}
  data _⊢_ : Context → ★ → Set where
    var : ∀ {Γ α}   → α ∈ Γ → Γ ⊢ α
    ƛ_  : ∀ {Γ α β} → α ∷ Γ ⊢ β → Γ ⊢ α ⇒ β
    _$_ : ∀ {Γ α β} → Γ ⊢ α ⇒ β → Γ ⊢ α → Γ ⊢ β
  infix 4 _⊢_
  infixr 5 ƛ_
  infixl 10 _$_
\end{code}
The constructors above should be fairly self-explanatory: they correspond
exactly to the typing rules of the calculus. In the first rule we employed the
data type \D{\_∈\_} implenting De Bruijn indices. Second rule captures the
concept of λ-abstraction, and the last rule is function application.

We can see some examples now,
\begin{code}
  I : ∀ {Γ α} → Γ ⊢ α ⇒ α
  I = ƛ (var 𝟎)

  S : ∀ {Γ α β γ} → Γ ⊢ (α ⇒ β ⇒ γ) ⇒ (α ⇒ β) ⇒ α ⇒ γ
  S = ƛ ƛ ƛ var 𝟐 $ var 𝟎 $ (var 𝟏 $ var 𝟎)
\end{code}
Note how we use Agda polymorphism to construct a polymorphic term of our
calculus; there is no polymorhism in the calculus itself.

The advantage of this presentation is that only well-typed syntax is
representable. Thus, whenever we work with a term of our calculus, it is
guaranteed to be well-typed, which often simplifiest things. We will see an
example of this in the next section.
\subsubsection{Semantics by Embedding into Agda}
Now that we have defined the syntax, the next step is to give it semantics. We
will do this in a straightforward manned by way of embedding our calculus into
Agda.

First, we define the semantics of types, by assigning Agda types to types in our calculus.
\begin{code}
  ⟦_⟧★ : ★ → Set
  ⟦ ι ⟧★     = ℕ
  ⟦ α ⇒ β ⟧★ = ⟦ α ⟧★ → ⟦ β ⟧★
\end{code}
Here we choose to realize our atomic type as the type of Natural numbers. These
are chosen for being a nontrivial type. The function type is realized
inductively as the Agda function type.

Next, we give semantics to contexts.
\begin{code}
  ⟦_⟧C : Context → Set
  ⟦ [] ⟧C     = ⊤
  ⟦ x ∷ xs ⟧C = ⟦ x ⟧★ × ⟦ xs ⟧C
\end{code}
The empty context can be realized trivially by the unit type. A non-empty
context is realized as the product type of the realization of the first element
and a realization of the rest of the context.

Now we are ready to give semantics to terms. In order to be able to proceed by
induction with regard to the structure of the term, we must operate on open terms.
\begin{code}
  ⟦_⟧ : ∀ {Γ α} → Γ ⊢ α → ⟦ Γ ⟧C → ⟦ α ⟧★
\end{code}
The second argument is a realization of the context in the term, which we will
need for variables,
\begin{code}
  ⟦ var here ⟧ (x , _)       = x
  ⟦ var (there x) ⟧ (_ , xs) = ⟦ var x ⟧ xs
\end{code}
Here we case-split on the variable, in case it is zero we take the first element
of the context, otherwise we recurse into the context until we hit zero. Note
that the shape of the context Γ is guaranteed here to never be empty, because the
argument to \I{var} is a proof of membership for Γ. Thus, Agda realizes that Γ
can never be empty and we need not bother ourselves with a case-split for the
empty context; indeed, we would be hard-pressed to give it an implementation.
\begin{code}
  ⟦ ƛ x ⟧ γ                  = λ ⟦α⟧ → ⟦ x ⟧ (⟦α⟧ , γ)
\end{code}
The case for lambda abstraction constructs an Agda function which will take as
the argument a value of the corresponding type and compute the semantics for the
lambda's body, after extending the context with the argument.
\begin{code}
  ⟦ f $ x ⟧ γ                = (⟦ f ⟧ γ) (⟦ x ⟧ γ)
\end{code}
Finally, to give semantics to function application, we simply perform Agda
function application on the subexpressions, after having computed their
semantics in the current context.

Thanks to propositional equality, we can embed tests directly into Agda code and
see whether the terms we defined above receive the expected semantics.
\begin{code}
  Iℕ : ℕ → ℕ
  Iℕ x = x

  _ : ⟦ I ⟧ ⋅ ≡ Iℕ
  _ = refl

  Sℕ : (ℕ → ℕ → ℕ) → (ℕ → ℕ) → ℕ → ℕ
  Sℕ x y z = x z (y z)

  _ : ⟦ S ⟧ ⋅ ≡ Sℕ
  _ = refl
\end{code}
Since this thesis can only be rendered if all the Agda code has successfully
type-checked, the fact that the reader is currently reading this paragraph means
the semantics function as expected!
\section{Coinduction}
\begin{code}
  record Thunk (A : Set) : Set where
    coinductive
    field
      force : A
  open Thunk public
\end{code}
\subsection{Examples of coinductive types}
\subsubsection{Coproducts}
\begin{code}
  record _+_ (A : Set) (B : Set) : Set where
    coinductive
    field
      injₗ : A
      injᵣ : B

  t : ℕ + ℕ
  _+_.injₗ t = {!!}
  _+_.injᵣ t = {!!}
\end{code}
\subsubsection{Streams}
\begin{code}
  data Stream (A : Set) : Set where
    _∷_ : A → Thunk (Stream A) → Stream A
\end{code}
\begin{code}
  iterate : ∀ {A} → A → (A → A) → Stream A
  iterate x f = x ∷ λ where .force → {!iterate (f x) f!}
\end{code}
\begin{code}
  _ : Stream ℕ
  _ = iterate 0 suc
\end{code}
\begin{code}
\end{code}
\subsection{Bisimilarity}
\subsection{The Delay Monad}

\begin{code}
open import Data.Integer using (ℤ; +_; _+_; _-_; _*_)
open import Data.Maybe using (Maybe; just)
open import Data.Integer.Properties renaming (_≟_ to _≟ℤ_)
open import Codata.Thunk using (force)
open import Codata.Delay using (Delay; now; later; never; runFor) renaming (bind to _>>=_)


\end{code}

\chapter{SECD Machine}
\chapter{Formalization}
In this chapter, we approach the main topic of this thesis. We will formalize a
SECD machine in Agda, with typed syntax, and then proceed to define the
semantics by way of coinduction. Finally, we will define a typed λ calculus,
corresponding exactly to the capabilities of the SECD machine, and define a
compilation procedure from this calculus to typed SECD programs.

\section{Syntax}
\subsection{Preliminaries}
Before we can proceed, we shall require certain machinery to aid us in
formalizing the type system.

We define the data type \AgdaDatatype{Path}, parametrized by a binary relation,
whose values are finite sequences of values such that each value is in relation
with the next.
\begin{code}
data Path {A : Set} (R : A → A → Set) : A → A → Set where
  ∅    : ∀ {a} → Path R a a
  _>>_ : ∀ {a b c} → R a b → Path R b c → Path R a c
infixr 5 _>>_
\end{code}
The first constructor creates an empty path. The second takes an
already-existing path and prepends to it a value, given a proof that this value
is in relation with the first element of the already-existing path. The reader
may notice a certain similarity to linked lists; indeed if for the relation we
take the universal one for our data type \AgdaDatatype{A}, then we obtain a type
that's isomorphic to linked lists.

We also define a shorthand for constructing the end of a path.
\begin{code}
_>|_ : ∀ {A R} {a b c : A} → R a b → R b c → Path R a c
a >| b = a >> b >> ∅
\end{code}
Furthermore, we can also append two paths, given that the end of the first path
matches the start of the second one.
\begin{code}
_>+>_ : ∀ {A R} {a b c : A} → Path R a b → Path R b c → Path R a c
∅ >+> r = r
(x >> l) >+> r = x >> (l >+> r)
infixr 4 _>+>_
\end{code}
\subsection{Machine types}
We start by defining the atomic constants our machine will recognize. We will
limit ourselves to booleans and integers.
\begin{code}
data Const : Set where
  true false : Const
  int : ℤ → Const
\end{code}
Next, we define which types our machine recognizes.
\begin{code}
data Type : Set where
  intT boolT : Type
  pairT : Type → Type → Type
  listT : Type → Type
  _⇒_ : Type → Type → Type
infixr 15 _⇒_
\end{code}
Firstly, there are types corresponding to the constants we have already defined
above. Then, we also introduce a product type and a list type. Finally, there is
the function type, \AgdaInductiveConstructor{\_⇒\_}, in infix notation.

Now we define the type assignment of constants.
\begin{code}
typeof : Const → Type
typeof true    = boolT
typeof false   = boolT
typeof (int x) = intT
\end{code}
Next, we define the typed stack, environment, and function dump.
\begin{code}
Stack   = List Type
Env     = List Type
FunDump = List Type
\end{code}
For now, these only store the information regarding the types of the values in
the machine. Later, when defining semantics, we will give realizations to these,
similarly to how we handled contexts in the formalization of Simply Typed λ
Calculus in ?.

Finally, we define the state as a record storing the stack, environment, and the
function dump.
\begin{code}
record State : Set where
  constructor _#_#_
  field
    s : Stack
    e : Env
    f : FunDump
\end{code}
Note that, unlike in the standard presentation of SECD Machines which we saw in
chapter ?, here the state does not include the code. This is because we are
aiming for a version of SECD with typed assembly code. We will define code in
what follows.
\subsection{Typing relation}
Since we aim to have typed assembly, we have to take a different approach to
defining code. We will define a binary relation, which determines how a state of
a certain shape is mutated following the execution of an instruction.

We will have two versions of this relation: first one is the single-step
relation, the second one is the transitive closure of the first one using
\D{Path}.
\begin{code}
infix 5 ⊢_⊳_
infix 5 ⊢_↝_
\end{code}
Their definitions need to be mutually recursive, because certain instructions —
defined in the single-step relation — need to refer to whole programs, a concept
captured by the multi-step relation.
\begin{code}
mutual
  ⊢_↝_ : State → State → Set
  ⊢ s₁ ↝ s₂ = Path ⊢_⊳_ s₁ s₂
\end{code}
Here there is nothing surprising, we use \D{Path} to define the multi-step
relation.

Next, we define the single-step relation. As mentioned before, this relation
captures how one state might change into another.
\begin{code}
  data ⊢_⊳_ : State → State → Set where
\end{code}
Here we must define all the instructions our machine should handle. We will start
with the simpler ones.
\begin{code}
    ldc  : ∀ {s e f}
         → (const : Const)
         → ⊢ s # e # f ⊳ (typeof const ∷ s) # e # f
\end{code}
Instruction \I{ldc} loads a constant which is embedded in it. It poses no
restrictions on the state of the machine and mutates the state by pushing the
constant on the stack.       
\begin{code}
    ld   : ∀ {s e f a}
         → (a ∈ e)
         → ⊢ s # e # f ⊳ (a ∷ s) # e # f
\end{code}
Instruction \I{ld} loads a value of type \A{a} from the environment and puts it
on the stack. It requires a proof that this value is, indeed, in the
environment.
\begin{code}
    ldf  : ∀ {s e f a b}
         → (⊢ [] # (a ∷ e) # (a ⇒ b ∷ f) ↝ [ b ] # (a ∷ e) # (a ⇒ b ∷ f))
         → ⊢ s # e # f ⊳ (a ⇒ b ∷ s) # e # f
\end{code}
The \I{ldf} instruction is considerably more involved. It loads a function of
the type \I{a ⇒ b} and puts it on the stack. Note how we use the multi-step
relation here. In addition, the code we are loading also has to be of a certain
shape to make it a function: the argument it was called with must be put in the
environment, and the function dump is to be extended with the type of the
function to permit recursive calls to itself.

Once a function is loaded, we may apply it,
\begin{code}
    ap   : ∀ {s e f a b}
         → ⊢ (a ∷ a ⇒ b ∷ s) # e # f ⊳ (b ∷ s) # e # f
\end{code}
\I{ap} requires that a function and it's argument are on the stack. After it has
run, the returning value from the function will be put on the stack in their
stead. The type of this instruction is fairly simple; the difficult part awaits
us further on in implementation.
\begin{code}
    rtn  : ∀ {s e a b f}
         → ⊢ (b ∷ s) # e # (a ⇒ b ∷ f) ⊳ [ b ] # e # (a ⇒ b ∷ f)
\end{code}
Return is an instruction we are to use at the end of a function in order to get
the machine state into the one required by \I{ldf}.

Next, let us look at recursive calls.
\begin{code}
    ldr  : ∀ {s e f a b}
         → (a ⇒ b ∈ f)
         → ⊢ s # e # f ⊳ (a ⇒ b ∷ s) # e # f
\end{code}
\I{ldr} loads a function for recursive application from the function dump. The
function in question might be the one we are currently in, or it might be many
scopes above the current function. In either case, the type of the function is
hereby guaranteed.
\begin{code}
    rap  : ∀ {s e f a b}
         → ⊢ (a ∷ a ⇒ b ∷ s) # e # f ⊳ [ b ] # e # f
\end{code}
This instruction looks exactly the same way as \I{ap}. The difference will be in
implementation, as this one will attempt to perform tail call elimination.
\begin{code}
    if   : ∀ {s s' e f}
         → ⊢ s # e # f ↝ s' # e # f
         → ⊢ s # e # f ↝ s' # e # f
         → ⊢ (boolT ∷ s) # e # f ⊳ s' # e # f
\end{code}
The if instruction requires that a boolean value be present on the stack. Based
on this, it decides which branch to execute. Here we hit on one limitation of
the typed presentation: both branches must finish a stack of the same shape,
otherwise it would be unclear how the stack looks like after this instruction.

The remaining instructions are fairly simple in that they only manipulate the
stack. Maybe we will show you only a few of them and hide the rest later.
\begin{code}
    lett : ∀ {s e f x}
         → ⊢ (x ∷ s) # e # f ⊳ s # (x ∷ e) # f
    nil  : ∀ {s e f a}
         → ⊢ s # e # f ⊳ (listT a ∷ s) # e # f
    flp  : ∀ {s e f a b}
         → ⊢ (a ∷ b ∷ s) # e # f ⊳ (b ∷ a ∷ s) # e # f
    cons : ∀ {s e f a}
         → ⊢ (a ∷ listT a ∷ s) # e # f ⊳ (listT a ∷ s) # e # f
    head : ∀ {s e f a}
         → ⊢ (listT a ∷ s) # e # f ⊳ (a ∷ s) # e # f
    tail : ∀ {s e f a}
         → ⊢ (listT a ∷ s) # e # f ⊳ (listT a ∷ s) # e # f
    pair : ∀ {s e f a b}
         → ⊢ (a ∷ b ∷ s) # e # f ⊳ (pairT a b ∷ s) # e # f
    fst  : ∀ {s e f a b}
         → ⊢ (pairT a b ∷ s) # e # f ⊳ (a ∷ s) # e # f
    snd  : ∀ {s e f a b}
         → ⊢ (pairT a b ∷ s) # e # f ⊳ (b ∷ s) # e # f
    add  : ∀ {s e f}
         → ⊢ (intT ∷ intT ∷ s) # e # f ⊳ (intT ∷ s) # e # f
    sub  : ∀ {s e f}
         → ⊢ (intT ∷ intT ∷ s) # e # f ⊳ (intT ∷ s) # e # f
    mul  : ∀ {s e f}
         → ⊢ (intT ∷ intT ∷ s) # e # f ⊳ (intT ∷ s) # e # f
    eq?  : ∀ {s e f a}
         → ⊢ (a ∷ a ∷ s) # e # f ⊳ (boolT ∷ s) # e # f
    not  : ∀ {s e f}
         → ⊢ (boolT ∷ s) # e # f ⊳ (boolT ∷ s) # e # f
\end{code}
\subsubsection{Derived instructions}
For the sake of sanity we will also define what amounts to simple programs,
masquerading as instructions, for use in more complex programs later. The chief
limitation here is that since these are members of the multi-step relation, we
have to be mindful when using them and use concatenation of paths, \F{_>+>_}, as
necessary.
\begin{code}
nil? : ∀ {s e f a} → ⊢ (listT a ∷ s) # e # f ↝ (boolT ∷ s) # e # f
nil? = nil >| eq?

loadList : ∀ {s e f} → List ℕ → ⊢ s # e # f ↝ (listT intT ∷ s) # e # f
loadList [] = nil >> ∅
loadList (x ∷ xs) = (loadList xs) >+> (ldc (int (+ x)) >| cons)
\end{code}
The first one is simply the check for an empty list. The second one is more
interesting, it constructs a sequence of instructions which will load a list of
natural numbers.
\subsection{Examples}
In this section we present some examples of SECD programs in our current
formalism. Starting with trivial ones, we will work our way up to using full
capabilities of the machine.
\begin{code}
2+3 : ⊢ [] # [] # [] ↝ [ intT ] # [] # []
2+3 =
    ldc (int (+ 2))
 >> ldc (int (+ 3))
 >| add
\end{code}
\begin{code}
inc : ∀ {e f} → ⊢ [] # (intT ∷ e) # (intT ⇒ intT ∷ f) ↝ [ intT ] # (intT ∷ e) # (intT ⇒ intT ∷ f)
inc =
    ld 𝟎
 >> ldc (int (+ 1))
 >> add
 >| rtn
\end{code}
\begin{code}
inc2 : ⊢ [] # [] # [] ↝ [ intT ] # [] # []
inc2 =
    ldf inc
 >> ldc (int (+ 2))
 >| ap
\end{code}
\begin{code}
λTest : ⊢ [] # [] # [] ↝ [ intT ] # [] # []
λTest =
     ldf -- First, we construct the curried function.
       (ldf
         (ld 𝟎 >> ld 𝟏 >> add >| rtn) >| rtn)
  >> ldc (int (+ 1)) -- Load first argument.
  >> ap              -- Apply b curried function. Results in a closure.
  >> ldc (int (+ 2)) -- Load second argument.
  >| ap              -- Apply b closure.
\end{code}
\begin{code}
-- λa.λb.a+b
-- withEnv test. Below is what withEnv desugars b.
-- plus : ∀ {e f} → ⊢ [] # e # f ↝ [ closureT intT (closureT intT intT (intT ∷ e)) e ] # e # f
plus : ∀ {s e f} → ⊢ s # e # f ⊳ ((intT ⇒ intT ⇒ intT) ∷ s) # e # f
plus = ldf (ldf (ld 𝟎 >> ld 𝟏 >> add >| rtn) >| rtn)

\end{code}
\begin{code}
-- Shit getting real.
foldl : ∀ {e f} → ⊢ [] # e # f ⊳ [ ((intT ⇒ intT ⇒ intT) ⇒ intT ⇒ (listT intT) ⇒ intT) ] # e # f
-- Below is the Agda-polymorphic version which does not typecheck. Something b do with how `withEnv e b` does not normalize further.
-- foldl : ∀ {a b e f} → ⊢ [] # e # f ↝ [ withEnv e ((b ⇒ a ⇒ b) ⇒ b ⇒ (listT a) ⇒ b)] # e # f
-- Explicitly typing out the polymorhic version, however, works:
--foldl : ∀ {a b e f} → ⊢ [] # e # f ⊳ [
--         closureT                            -- We construct a function,
--             (closureT b (closureT a b (b ∷ e)) e) -- which takes the folding function,
--             (closureT b                     -- returning a function which takes acc,
--               (closureT (listT a)           -- returning a function which takes the list,
--                 b                           -- and returns the acc.
--                 (b ∷ (closureT b (closureT a b (b ∷ e)) e) ∷ e))
--               ((closureT b (closureT a b (b ∷ e)) e) ∷ e))
--             e
--         ] # e # f
-- BDO: figure out what's going on 𝟎 if has time.
foldl = ldf (ldf (ldf body >| rtn) >| rtn)
  where
    body =
         ld 𝟎                   -- Load list.
      >> nil?                      -- Is it empty?
      >+> if (ld 𝟏 >| rtn) -- If so, load & return acc.
          (ld 𝟐     -- If not, load folding function.
        >> ld 𝟏           -- Load previous acc.
        >> ap                      -- Partially apply folding function.
        >> ld 𝟎                 -- Load list.
        >> head                    -- Get the first element.
        >> ap                      -- Apply, yielding new acc.
        >> ldr 𝟐     -- Partially-tail apply the folding function b us.
        >> ld 𝟐     -- Load the folding function.
        >> ap >> flp >> ap >> ld 𝟎 >> tail >| rap) >> ∅                      -- Apply acc, result in another closure.
--        >> ap                      -- Apply acc, result in another closure.
--        >> ld 𝟎                 -- Load list.
--        >> tail                    -- Drop the first element we just processed.
--        >| rap)                      -- Finally apply the last argument, that rest of the list.

mutual
  ⟦_⟧ᵉ : Env → Set
  ⟦ [] ⟧ᵉ     = ⊤
  ⟦ x ∷ xs ⟧ᵉ = ⟦ x ⟧ᵗ × ⟦ xs ⟧ᵉ

  ⟦_⟧ᵈ : FunDump → Set
  ⟦ [] ⟧ᵈ                    = ⊤
  ⟦ intT ∷ xs ⟧ᵈ = ⊥
  ⟦ boolT ∷ xs ⟧ᵈ = ⊥
  ⟦ pairT x x₁ ∷ xs ⟧ᵈ = ⊥
  ⟦ a ⇒ b ∷ xs ⟧ᵈ = Closure a b × ⟦ xs ⟧ᵈ
  ⟦ listT x ∷ xs ⟧ᵈ = ⊥

  record Closure (a b : Type) : Set where
    inductive
    constructor ⟦_⟧ᶜ×⟦_⟧ᵉ×⟦_⟧ᵈ
    field
      {e} : Env
      {f} : FunDump
      ⟦c⟧ᶜ : ⊢ [] # (a ∷ e) # (a ⇒ b ∷ f) ↝ [ b ] # (a ∷ e) # (a ⇒ b ∷ f)
      ⟦e⟧ᵉ : ⟦ e ⟧ᵉ
      ⟦f⟧ᵈ : ⟦ f ⟧ᵈ

  ⟦_⟧ᵗ : Type → Set
  ⟦ intT ⟧ᵗ           = ℤ
  ⟦ boolT ⟧ᵗ          = Bool
  ⟦ pairT t₁ t₂ ⟧ᵗ    = ⟦ t₁ ⟧ᵗ × ⟦ t₂ ⟧ᵗ
  ⟦ a ⇒ b ⟧ᵗ       = Closure a b
  ⟦ listT t ⟧ᵗ        = List ⟦ t ⟧ᵗ

⟦_⟧ˢ : Stack → Set
⟦ [] ⟧ˢ     = ⊤
⟦ x ∷ xs ⟧ˢ = ⟦ x ⟧ᵗ × ⟦ xs ⟧ˢ

lookupᵉ : ∀ {x xs} → ⟦ xs ⟧ᵉ → x ∈ xs → ⟦ x ⟧ᵗ
lookupᵉ (x , _) here       = x
lookupᵉ (_ , xs) (there w) = lookupᵉ xs w

tailᵈ : ∀ {x xs} → ⟦ x ∷ xs ⟧ᵈ → ⟦ xs ⟧ᵈ
tailᵈ {intT} ()
tailᵈ {boolT} ()
tailᵈ {pairT x x₁} ()
tailᵈ {a ⇒ b} (_ , xs) = xs
tailᵈ {listT x} ()

--lookupᵈ : ∀ {x xs} → ⟦ xs ⟧ᵈ → x ∈ xs → ⟦ x ⟧ᶜˡ
--lookupᵈ {mkClosureT _ _ _} (x , _) 𝟎 = x
--lookupᵈ {mkClosureT _ _ _} list (t𝟎 at) = lookupᵈ (tailᵈ list) at

lookupᵈ : ∀ {a b f} → ⟦ f ⟧ᵈ → a ⇒ b ∈ f → Closure a b
lookupᵈ (x , _) here = x
lookupᵈ f (there w) = lookupᵈ (tailᵈ f) w

run : ∀ {s s' e e' f f' i} → ⟦ s ⟧ˢ → ⟦ e ⟧ᵉ → ⟦ f ⟧ᵈ → ⊢ s # e # f ↝ s' # e' # f'
                           → Delay ⟦ s' ⟧ˢ i
run s e d ∅ = now s
run s e d (ldf code >> r) = run (⟦ code ⟧ᶜ×⟦ e ⟧ᵉ×⟦ d ⟧ᵈ , s) e d r
run s e d (ldr at >> r) = run (lookupᵈ d at , s) e d r
run (a , ⟦ code ⟧ᶜ×⟦ fE ⟧ᵉ×⟦ dump ⟧ᵈ , s) e d (ap >> r) =
  later λ where .force → do
                           (b , _) ← run ⋅ (a , fE) (⟦ code ⟧ᶜ×⟦ fE ⟧ᵉ×⟦ dump ⟧ᵈ , dump) code
                           run (b , s) e d r
run (a , ⟦ code ⟧ᶜ×⟦ fE ⟧ᵉ×⟦ dump ⟧ᵈ , s) e d (rap >> ∅) =
  later λ where .force → run ⋅ (a , fE) (⟦ code ⟧ᶜ×⟦ fE ⟧ᵉ×⟦ dump ⟧ᵈ , dump) code
run (a , ⟦ code ⟧ᶜ×⟦ fE ⟧ᵉ×⟦ dump ⟧ᵈ , s) e d (rap >> x >> r) =
  later λ where .force → run (a , ⟦ code ⟧ᶜ×⟦ fE ⟧ᵉ×⟦ dump ⟧ᵈ , ⋅) e d (ap >> x >> r)
run (b , _) e d (rtn >> r) = run (b , ⋅) e d r
run (x , s) e d (lett >> r)      = run s (x , e) d r
run s e d (nil >> r)             = run ([] , s) e d r
run s e d (ldc const >> r)       = run (makeConst const , s) e d r
  where makeConst : (c : Const) → ⟦ typeof c ⟧ᵗ
        makeConst true    = tt
        makeConst false   = ff
        makeConst (int x) = x
run s e d (ld at >> r)           = run (lookupᵉ e at , s) e d r
run (x , y , s) e d (flp >> r)   = run (y , x , s) e d r
run (x , xs , s) e d (cons >> r) = run (x ∷ xs , s) e d r
run ([] , s) e d (head >> r)     = never
run (x ∷ _ , s) e d (head >> r)  = run (x , s) e d r
run ([] , s) e d (tail >> r)     = never
run (x ∷ xs , s) e d (tail >> r) = run (xs , s) e d r
run (x , y , s) e d (pair >> r)  = run ((x , y) , s) e d r
run ((x , _) , s) e d (fst >> r) = run (x , s) e d r
run ((_ , y) , s) e d (snd >> r) = run (y , s) e d r
run (x , y , s) e d (add >> r)   = run (x + y , s) e d r
run (x , y , s) e d (sub >> r)   = run (x - y , s) e d r
run (x , y , s) e d (mul >> r)   = run (x * y , s) e d r
run (a , b , s) e d (eq? >> r)   = run (compare a b , s) e d r
  where compare : {t₁ t₂ : Type} → ⟦ t₁ ⟧ᵗ → ⟦ t₂ ⟧ᵗ → ⟦ boolT ⟧ᵗ
        compare {intT} {intT} a b   = ⌊ a ≟ℤ b ⌋
        compare {boolT} {boolT} a b = ⌊ a ≟B b ⌋
        compare {pairT _ _} {pairT _ _} (a₁ , a₂) (b₁ , b₂) = (compare a₁ b₁) ∧ (compare a₂ b₂)
        compare {listT xs} {listT ys} a b = ⌊ length a ≟ℕ length b ⌋ -- BDO
        compare {_} {_} _ _ = ff
run (x , s) e d (not >> r)       = run (¬ x , s) e d r
run (bool , s) e d (if c₁ c₂ >> r) with bool
… | tt = later λ where .force → run s e d (c₁ >+> r)
… | ff = later λ where .force → run s e d (c₂ >+> r)

runℕ : ∀ {x s} → ⊢ [] # [] # [] ↝ (x ∷ s) # [] # [] → ℕ → Maybe ⟦ x ⟧ᵗ
runℕ c n = runFor n
  do
    (x , _) ← run ⋅ ⋅ ⋅ c
    now x


_ : runℕ 2+3 1 ≡ just (+ 5)
_ = refl

_ : runℕ inc2 2 ≡ just (+ 3)
_ = refl

_ : runℕ λTest 3 ≡ just (+ 3)
_ = refl

foldTest : ⊢ [] # [] # [] ↝ [ intT ] # [] # []
foldTest =
     foldl
  >> plus
  >> ap
  >> ldc (int (+ 0))
  >> ap
  >> (loadList (1 ∷ 2 ∷ 3 ∷ 4 ∷ []))
  >+> ap
  >> ∅

_ : runℕ foldTest 29 ≡ just (+ 10)
_ = refl


Ctx = List Type

infix 2 _×_⊢_
data _×_⊢_ : Ctx → Ctx → Type → Set where
  var : ∀ {Ψ Γ x} → x ∈ Γ → Ψ × Γ ⊢ x
  ƛ_  : ∀ {Ψ Γ α β} → (α ⇒ β ∷ Ψ) × α ∷ Γ ⊢ β → Ψ × Γ ⊢ α ⇒ β
  _$_ : ∀ {Ψ Γ α β} → Ψ × Γ ⊢ α ⇒ β → Ψ × Γ ⊢ α → Ψ × Γ ⊢ β
  rec : ∀ {Ψ Γ α β} → (α ⇒ β) ∈ Ψ → Ψ × Γ ⊢ α ⇒ β
  if_then_else_ : ∀ {Ψ Γ α} → Ψ × Γ ⊢ boolT → Ψ × Γ ⊢ α → Ψ × Γ ⊢ α → Ψ × Γ ⊢ α
  _==_ : ∀ {Ψ Γ} → Ψ × Γ ⊢ intT → Ψ × Γ ⊢ intT → Ψ × Γ ⊢ boolT
  #_ : ∀ {Ψ Γ} → ℤ → Ψ × Γ ⊢ intT
  #⁺_ : ∀ {Ψ Γ} → ℕ → Ψ × Γ ⊢ intT
  mul : ∀ {Ψ Γ} → Ψ × Γ ⊢ intT ⇒ intT ⇒ intT
  sub : ∀ {Ψ Γ} → Ψ × Γ ⊢ intT ⇒ intT ⇒ intT
infixr 2 ƛ_
infixl 3 _$_
infix 5 _==_


fac : [] × [] ⊢ (intT ⇒ intT)
fac = ƛ if (var 𝟎 == #⁺ 1)
          then #⁺ 1
          else (mul $ (rec 𝟎 $ (sub $ var 𝟎 $ #⁺ 1))
                    $ var 𝟎)

mutual
  compileT : ∀ {Ψ Γ α β} → (α ⇒ β ∷ Ψ) × (α ∷ Γ) ⊢ β → ⊢ [] # (α ∷ Γ) # (α ⇒ β ∷ Ψ) ↝ [ β ] # (α ∷ Γ) # (α ⇒ β ∷ Ψ)
  compileT (f $ x) = compile f >+> compile x >+> rap >> ∅
  compileT (if t then a else b) = compile t >+> if (compileT a) (compileT b) >> ∅
  compileT t = compile t >+> rtn >> ∅

  compile : ∀ {Ψ Γ α s} → Ψ × Γ ⊢ α → ⊢ s # Γ # Ψ ↝ (α ∷ s) # Γ # Ψ
  compile (var x) = ld x >> ∅
  compile (ƛ t) = ldf (compileT t) >> ∅
  compile (f $ x) = compile f >+> compile x >+> ap >> ∅
  compile (rec x) = ldr x >> ∅
  compile (if t then a else b) = compile t >+> if (compile a) (compile b) >> ∅
  compile (a == b) = compile b >+> compile a >+> eq? >> ∅
  compile (# x) = ldc (int x) >> ∅
  compile (#⁺ x) = ldc (int (+ x)) >> ∅
  compile mul = ldf (ldf (ld 𝟎 >> ld 𝟏 >| mul) >| rtn) >> ∅
  compile sub = ldf (ldf (ld 𝟎 >> ld 𝟏 >| sub) >| rtn) >> ∅

_ : runℕ (compile (fac $ #⁺ 5)) 27 ≡ just (+ 120)
_ = refl

\end{code}

\chapter{Epilogue}

\end{document}
