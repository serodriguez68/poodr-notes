# Practical Object-Oriented Design in  Ruby - Notes
Notes by: __[Sergio Rodriguez](https://github.com/serodriguez68 "Sergio's Github")__ / Book by: __[Sandi Metz](https://github.com/skmetz "Sandi's Github")__

__These are some notes I took while reading the book. Feel free to send me a pull request if you want to make an improvement.__
_______________________________________________________________________________

# Chapter 1 - Object Oriented Design
## Why Design?
* Changes in applications are unavoidable.
* Change is hard because of the dependencies between objects 
    * The sender of the message knows things about the receiver
    * Tests assume too much about how objects are built
* Good design gives you room to move in the future
    *  __The purpose of design is to allow you to do design later, and its primary goal is to reduce the cost of change.__
    * It __does not__ anticipate the future (this almost always goes badly)

## The Tools of Design
### Design Principles
* [SOLID Design](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design))
    * **Single Responsibility Principle:** a class should have only a single responsibility. [(See Ch2)](#chapter-2---designing-classes-with-a-single-responsibility).
    * **Open-Closed:** Software entities should be open for extension, but closed for modification (inherit instead of modifying existing classes).
    * **Liskov Substitution:** Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.
    <!-- WIP: add internal link -->
    * **Interface Segregation:** Many client-specific interfaces are better than one general-purpose interface.
    <!-- WIP: add internal link -->
    * **Dependency Inversion:** Depend upon Abstractions. Do not depend upon concretions.
    <!-- WIP: add link to dependency inversion -->
* **Don't Repeat Yourself:** Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
* **Law of Demeter:** A given object should assume as little as possible about the structure or properties of anything else.

### Design Patterns
> Simple and elegant solutions to specific problems in OOP that you can use to make your own designs more flexible, modular reusable and understandable.

_This book is not about patterns. However, it will help you understand them and choose between them._

## The Act of Design
### How Design Fails (When Design Fails)

Design fails when:

* Principles are applied inappropriately.
* Patterns are misapplied (see and use patterns where none exist).
* The act of design is separated from the act of programming.
    * __Follow__ Agile, __NOT__ Big Up Front Design (BUFD)

### When to Design
* __Do__ Agile Software development.
* __Don't do__ Big Up Front Design (BUFD).
    * Designs in BUFD cannot possibly be correct as many things will change during the act of programming.
    * BUFD inevitable leads to an adversarial relationship between customers and programmers.
* Make design decisions only when you must with the information you have at that time (postpone decisions until you are absolutely forced to make them).
    - Any decision you make in advance on an explicit requirement is just a guess. Preserve your ability to make a decision _later_.

### Judging Design
There are multiple metrics to help you measure how well your code follows OOD principles. Take into account the following:

* Bad OOD metrics are an indisputable sign of bad design (code that scores poorly __will be hard to change__).
* Good scores don't guarantee that the next change you make will be easy.
    * Applications may be anticipating the wrong future (_Don't try to anticipate the future_).
    * Applications may be doing the wrong thing in the right way.
* Metrics are proxies for a deeper measurement.
*  How much design you do depends on two things: 1) Your skills, 2) Your timeframe.
    *  There is a tradeoff between the amount of time spent designing and the amount of time this design saves in the future (and there is a break-even point).
    *  With experience you will learn how to apply design in the right time and in the right amount.

_______________________________________________________________________________
# Chapter 2 - Designing Classes with a Single Responsibility
* A class should do the smallest possible useful thing.
* Your goal is to make classes that do what they need to do _right now_ and are easy to change _later_.
* The code you write should have these qualities:
    * Changes have no unexpected side effects.
    * Small changes in requirements = small changes in code.
    * Easy to reuse.
    * The easiest way to make a change is to add code that in itself is easy to change (Exemplary code).
    
## Creating classes with single responsibility
* A class __must__ have __data__ and __behavior__ (methods).  If one of these is missing, the code doesn't belong to a class.

### Determining if a class has a single responsibility
* __Technique 1: Ask questions for each of it's methods.__
    * _"Please Mr. Gear, what is your ratio?"_ - Makes sense = ok
    * _"Please Mr. Gear, what is your tire size?"_ - Doesn't make sense = does not belong here
* __Technique 2: Describe the class in one sentence.__
    * The description contains the words _"and"_ or _"or"_ = the class has more than one responsibility
    * If the description is concise but the class does much more than the description = the class is doing too much
    * Example: _"Calculate the effect that a gear has on a bicycle"_

## Writing Code that Embraces Change

### Depend on behavior (methods), Not Data

#### Hide Instance Variables
Never call @variables inside methods = user wrapper methods instead. 
[Wrong Code Example](code_examples/chapter_2.rb#L61-L71) / [Right Code Example](code_examples/chapter_2.rb#L73-L102)

#### Hide Data Structures
If the class uses complex data structures = Write wrapper methods that decipher the structure and depend on those methods.
[Wrong Code Example](code_examples/chapter_2.rb#L105-L117) / [Right Code Example](code_examples/chapter_2.rb#L124-L141)

### Enforce Single Responsibility Everywhere

#### Extract Extra Responsibilities from Methods
* Methods with single responsibility have these benefits:
    * Clarify what the class does.
    * Avoid the need for comments.
    * Encourage reuse.
    * Easy to move to another class (if needed).
* Same techniques as for classes work ([See techniques](#determining-if-a-class-has-a-single-responsibility)).
* Separate iteration from action (common case of single responsibility violation in methods).

#### Isolate Extra Responsibilities in Classes
If you are not sure if you will need another class but have identified a class with an extra responsibility, __isolate it__ ([Example using Struct.](code_examples/chapter_2.rb#L176-L197))
_______________________________________________________________________________
# Chapter 3 - Managing Dependencies
## Recognizing Dependencies
An object has a dependency when it knows ([See example code](code_examples/chapter_3.rb#L2-L34)): 

1. The name of another class. _(Gear expects a class named Wheet to exist.)_
    * Solution strategy 1: __[Inject Dependencies](#inject-dependencies)__
    * Solution strategy 2: __[Isolate Instance Creation](#isolate-instance-creation)__
2. The name of the message that it intends to send to someone other than self. (_Gear expects a Wheel instance to respond to diameter_).
    * Solution strategy 1: __[Reversing Dependencies](#reversing-dependencies)__
        - Avoids the problem from the beginning, but it is not always possible.
    * Solution strategy 2: __[Isolate Vulnerable External Messages](#isolate-vulnerable-external-messages)__
3. The arguments that a message requires. _(Gear knows that Wheel.new requires rim and title.)_
    * Mostly unavoidable dependency.
    * In some cases [default values](#explicitly-define-defaults) of arguments might help.
4. The order of those arguments. _(Gear knows the first argument to Wheel.new should be 'rim', 'tire' second.)_
    * Solution Strategy 1: __[Use Hashes for initialization arguments](#use-hashes-for-initialization-arguments)__
    * Solution Strategy 2: __[Use Default Values](#explicitly-define-defaults)__
    * Solution Strategy 3: __[Isolate Multiparameter Initialization](#isolate-multiparameter-initialization)__
        - When you can't change the original method (e.g when using an external interface).
        
\*_You may combine solution strategies if it makes sense._

>Some degree of dependency is inevitable, however most dependencies are unnecessary.

## Solution Strategies
### Inject Dependencies
Instead of explicitly calling another class' name inside a method, pass the instance of the other class as an argument to the method.
[Wrong Code Example](code_examples/chapter_3.rb#L37-L52) / [Right Code Example](code_examples/chapter_3.rb#L55-L67)

### Isolate Instance Creation
Use this if you can't get rid of "_the name of another class_" dependency type through dependency injection.

+ Technique 1: __Move external class name call to the initialize method.__ ([Example code](code_examples/chapter_3.rb#L73-L83))
+ Technique 2: __Isolate external class call in explicit defined method.__ ([Example code](code_examples/chapter_3.rb#L87-L102))

### Isolate Vulnerable External Messages
> For messages sent to someone other than _self_.

Not every external method is a candidate for isolation. External methods become candidates when the dependency becomes dangerous. For example:

+ The external method is buried inside other complex code.
+ There are multiple calls to the external methods inside the class.
+ The method is part of the [private interface of another class.](#r3-exercise-caution-when-depending-on-private-interfaces)

[Wrong Code Example](code_examples/chapter_3.rb#L111-L115) / [Right Code Example](code_examples/chapter_3.rb#L118-L126)

### Use Hashes for Initialization Arguments
+ You will be changing the argument order dependency for an argument name dependency.
    * Not a problem: argument name is more stable and provides explicit documentation of arguments.
+ The use of these technique depends on the case:
    * For very simple methods you are better off accepting the argument order dependency.
    * For complex method signatures, hashes are best.
    * There are many cases in between where some arguments are required as stable (dependent on order) and some are less stable or optional (dependent on names by hash).  This is fine.

[Wrong Code Example](code_examples/chapter_3.rb#L129-L142) / [Right Code Example](code_examples/chapter_3.rb#L145-L158)

### Explicitly Define Defaults
+ __Simple non-boolean defaults:__ '_||_' ([Code Sample](code_examples/chapter_3.rb#L161-L166))
    * Problem: you can't set an attribute to _nil_ or _false_ because the fallback value will take over.
+ __Hash as argument with simple defaults:__ _fetch_ ([Code Sample](code_examples/chapter_3.rb#L169-L174))
    * _Fetch_ depends on the __existence__ of the key.  If the key is not present, it returns the fallback value.
        - This means that attributes can be set to _nil_ and _false_, without the fallback value taking over.
+ __Hash as argument with complex defaults:__ _defaults method + merge_ ([Code Sample](code_examples/chapter_3.rb#L177-L186))
    * The _defaults_ method is an independent method that handles the complex logic for defaults and returns a hash.  This hash is then merged to the actual _arguments hash_.

### Isolate Multiparameter Initialization 
For methods where you can't change the order of arguments (e.g external interfaces).

+ Wrap the external interface in a _module_ whose sole purpose is to create objects from the external dependency. ([Code Sample](code_examples/chapter_3.rb#L189-L209))
    * FYI: objects whose purpose is to create other objects are called _factories_.
+  Use a _module_, __not__ a Class because you don't expect to create instances of the module.

### Reversing dependencies
Imagine the case where _KlassA_ depends on _KlassB_. This is where _KlassA_ instantiates _KlassB_ or calls methods from _KlassB_.

You could write a version of the code were _KlassB_ depends con _KlassA_.
[Gear depends on Wheel Sample](code_examples/chapter_3.rb#L2-L34) / [Wheel depends on Gear Sample](code_examples/chapter_3.rb#L264-L300) 

#### Choosing Dependency Direction
> Depend on things that change less often than you do.

+ Some classes are more likely than others to have changes in requirements.
    * You can rank the likelihood of change of any classes you are using regardless of their origin (internal or external). This will help you to make decisions.
+ Concrete classes are more likely to change than __abstract classes__.
    * __Abstract Class:__ disassociated from any specific instance.
+ Changing a class that has many dependents will result in widespread consequences.
    * A class that if changed causes a catastrophe  has enormous pressure to _never_ change.
    * Your app may be forever handicapped because of having such types of classes.

#### Finding Dependencies that Matter
Not all dependencies are harmful. Use the following framework to organize your thoughts and help you find which of your classes are dangerous.

<img src="/images/ch3_likelihood_of_change_vs_dependents.png" width="600"/>

_______________________________________________________________________________
# Chapter 4 - Creating Flexible Interfaces
_Flexible interfaces: message based design, not class based design_
>The conversation between objects takes place using their _public interfaces_.

## Bad vs Good Interfaces 
__(Original: Understanding Interfaces)__

<img src="/images/ch4_communication_patterns.png" width="600"/>

+ __Bad Interface structure:__
    * Objects expose too much of themselves.
    * Objects know too much about neighbors.
    * __Result__: They do only the thing they are able to do right now.

> This design issue is not necessarily a failure of dependency injection or single responsibility. Those techniques, while necessary, are not enough to prevent the construction of an application whose design causes you pain. The roots of this new problem lie not in what each class _does_ but with what it _reveals_. 
    
+ __Good Interface structure:__
    * Objects reveals as little of themselves as possible.
    * Objects know as little of their neighbors as possible.
    * __Result__: plug-able, component-like objects.

##  Defining interfaces
>On a restaurant the kitchen does many things but does not, expose them all to its customers. It has a __public__ interface that customers are expected to use: the menu. Within the kitchen many things happen, many other messages get passed, but these messages are __private__ and thus invisible to customers. Even though they may have ordered it, customers are not welcome to come in and stir the soup.

>The menu lets customers ask for __what__ they want without knowing anything about __how__ the kitchen makes it.

### Public Interfaces
+ Reveals the class' primary responsibility.
    * The public interface should correspond to the class' responsibility. A single responsibility may require multiple public methods. However, too many loosely related public methods can be a sign of __single responsibility violation.__
+ Are expected to be invoked by others.
+ Will not change on a whim.
+ Are safe for other to depend on.
    * (Depend on _less_ changeable things)
+ Are thoroughly documented in tests.

### Private Interfaces
+ Handle implementation details (utility methods only meant to be used internally).
+ Are not expected to be sent by other objects.
+ Can change for any reason whatsoever 
    * (And it's safe for them to change as the public interface should remain stable).
+ Are unsafe for others to depend on.
+ May not even be referenced in tests.

## Finding a good public interface
__(Original: Finding the public interface)__

__Focus on messages, NOT domain objects (classes)__

>Design experts notice domain objects without concentrating on them; they focus not on these objects but on the messages that pass between them. These messages are guides that lead you to discover other objects, ones that are just as necessary but far less obvious.

### Step 1: Using Sequence Diagrams

 + Lightweight way of acquiring a design intention.
 + Low cost object arrangement and message passing (public interface) experiments.
 + Helpful for communicating ideas.
 + __Keep agile__: use them for exerimenting and communicating. Do NOT do big up-front design.
 + Value of these diagrams:
    * __Should this receiver be responsible for responding to this message?__
    * __I need to send this message, who should respond to it?__
 
 <img src="/images/ch4_simple_sequence_diagram.png" width="400"/>

### Step 2: Asking for 'What' instead of telling 'How'

Better explained through an example: compare novice vs intermediate.

<img id="ch4_novice_vs_intermediate_experienced" src="/images/ch4_novice_vs_intermediate_experienced.png" width="800"/>

### Step 3: Seeking Context Independence
> Context: The things that a class knows about other objects.  In the [intermediate design example](#ch4_novice_vs_intermediate_experienced), Trip _has_ a single responsibility but _expects_ to be holding onto a _Mechanic_ capable of responding to _prepare bicyble_.

+ (+) context = (-) reusability = (-) testability ease
+ Use [dependency injection](#inject-dependencies) to seek context independence.
+ Better explained through an example: [compare intermediate vs experienced](#ch4_novice_vs_intermediate_experienced).

### Step 4: Trusting Other Objects
>I know what I want and I _trust your to do your part._

Better explained through an example: [compare intermediate vs experienced](#ch4_novice_vs_intermediate_experienced).

### Using Messages to Discover Objects
A message based approach (following these steps) can help you to discover _not so obvious_, but important objects. [See next example](#ch4_discovering_objects)

A message based approach also helps you to find the first thing to assert in a test.

<img id="ch4_discovering_objects" src="/images/ch4_discovering_objects.png" width="800"/>

## Writing Code That Puts Its Best (Inter)Face Forward

>Think about interfaces. Create them intentionally. It is your interfaces, more than all of your tests and any of your code, that define your application and determine it’s future.

__The following are rules-of-thumb for creating interfaces:__

### R1. Create Explicit Interfaces

+ Method in the __public interface__ should:
    * Be explicitly identified as such
    * Be more about _what_ than _how_
    * Have names that, insofar as you can anticipate, will not change
    * Take a hash as an options parameter
+ Do not test private methods. If you must, segregate those test from the ones of the public methods
+ In ruby: _public, private, protected keywords_
    * Use them if you like but take into account that ruby has mechanisims to circumvent them
    * You are better off using comments or a naming convention for public and private methods than using the keywords
        - Rails uses a leading '_' for private methods

### R2. Honor the Public Interfaces of Others

+ If your design forces the use of a private method in another class, __re-think your design__ (try very hard to find an alternative)
+ A dependency on a private method of an external framework is a form of technical debt

### R3. Exercise Caution When Depending on Private Interfaces

+ If you __must__ depend on a private interface, __[isolate the dependency](#isolate-vulnerable-external-messages)__
    * This will prevent calls from multiple places

### R4. Minimize Context

+ Create public methods that allow senders to get __what__ they want without knowing __how__ your class does it
+ If you face a class with an ill-defined public interface you have these options (depending on the case):
    * Option 1. Define a new well-defined method for that class' public interface.
    * Option 2. Create a wrapper class with a well defined public interface.
    * Option 3. Create a single wrapping method and put it in your own class.

## The Law of Demeter
>Only talk to your immediate neighbors.

>This is not an absolute law. Certain “violations” of Demeter reduce your application’s flexibility and maintainability, while others make perfect sense. Additionally, violations typically lead to objects that require a lot of _context_.

The definition _"only use one dot"_ is __not always right__. There are cases that use multiple dots that do not violate Demeter.

__Examples__:

+ customer.bicycle.wheel.tire
    * Type: __returns a distant attribute__
    * There is debate on how firmly Demeter applies. It may be cheapest in your specific case to reach through intermediate objects than to go around.
+ customer.bicycle.wheel.rotate
    * Type: __invokes distant behavior__
    * __Cost is high. Remove this type of violation.__
+ hash.keys.sort.join(', ')
    * __No violation__
    * See? The _"use only one dot"_ definition is not always right.
 
### Wrong approach to comply with Demeter: Delegation
Delegation removes visible violations but ignores Demeter's spirit. Using delegation to hide tight coupling is not the same as decoupling code.

+ Delegation in Ruby: _delegate.rb or forwardable.rb_
+ Delegation in Rails: _the delegate method_

### How to comply with Demeter
+ Demeter violations are clues of __missing objects whose public interface you have not yet discovered.__.
+ It is easy to comply with Demeter if you use a __message-based perspective__ in your design.

_______________________________________________________________________________
# Chapter 5 - Reducing Costs with Duck Typing

## Undestranding Duck Typing
+ __Duck types__ are public interfaces that are not tied to any specific Class.
    * Duck types are abstractions that share the public interface's name.
        - __Different objects respond to the same message__.
    * Senders of the message __do not care about the class of the receiver__.
    * Receivers supply their __own specific version of the behavior__.
+ Class is just one way for an object to acquire a public interface (it is one of several public interfaces it can contain).
+ It is not what an object _is_ that matters, it's what it _does_.

### Design in need of a Duck (Concretion) - Wrong
[Wrong Code Example](code_examples/chapter_5.rb#L27-L60)

<img id="ch5_1_design_in_need_of_duck" src="/images/ch5_1_design_in_need_of_duck.png" width="400"/>

__What is wrong with this approach:__

+ Explosion of dependencies (explicit name of classes, name of messages each class understands, arguments those messages require).
+ This style of code propagates itself. To add another preparer you need to create a dependency.
+ __Sequence diagrams should always be simpler than the code they represent; when they are not, something is wrong with the design.__

### Design with Duck (Abstraction) - Right
[Right Code Example](code_examples/chapter_5.rb#L64-L99)

<img id="ch5_2_design_with_duck" src="/images/ch5_2_design_with_duck.png" width="400"/>

__What is right with this approach:__

+ The _prepare_ method trusts all of its arguments to do their part.
+ Objects that implement _prepare_trip_ __are Preparers__ (this is the Duck Type abstraction).
    * This makes it very easy to change the code (add or remove preparers without the need to change Trip at all).

__Things to consider:__

+ Cost of Concretion VS Cost of Abstraction
    * __Concrete code:__ easy to understand, costly to extend.
    * __Abstract code:__ initially harder to understand, far easier to change.

## Writing code that Relies on Ducks
> It is relatively easy to implement a duck type; your design challenge is to notice that you need one and to abstract its interface.

### Recognizing Hidden Ducks
__The following coding styles are indications that you are missing a Duck:__

+ Case Statements that switch on class / If Statements with .class == "KlassName" ([Example](code_examples/chapter_5.rb#L102-L118))
+ __kind_of?__ and __is_a?__ ([Example](code_examples/chapter_5.rb#L121-L128))
+ __responds_to?__ ([Example](code_examples/chapter_5.rb#L131-L138))

### Documenting Duck Types
Tests are the best documentation. __You only need to write the tests.__

### Sharing Code Between Ducks
Ducks share the interface (method names) and __may__ share some code in the implementation inside the shared methods:

+ Share interface name but NOT code in methods: strategy described in this chapter.
+ Share interface name AND some code in methods: [See Ch7](#)
<!-- WIP: add link to chapter 7 -->

### Choosing Your Ducks Wisely
Some times Ducks can exist but may not be needed. [Here is an example from the Rails Framework](code_examples/chapter_5.rb#L144-L155).

Takeaways about this example:

+ This code is depending on Ruby's _Integer and Hash_ classes. They are far more stable than this method is (this is why ignoring the Duck isn't much of a deal).
+ There _is_ probably a hiding Duck here.
    * The implementation of a Duck will probably __not reduce the cost of the application.__
    *  The implementation of a Duck requires to monkey patch Ruby.
        - Feel free to monkey patch Ruby if needed. However, you need to be able to defend the decision.

## What about Duck Typing in Statically Typed Languages? 
__(Conquering a Fear of Duck Typing)__

The author compares both types of languages and makes an argument __in favor of dynamically typed languages__. Here are the takeaways from her discussion:

+ Duck Typing is not possible on static typed languages.
+ Metaprogramming is much easier in dynamic typed languages (strong argument in favor of dynamic typed languages).
+ When a dynamically typed application cannot be tuned to run quickly enough, static typing is the alternative. (If you must, you must).
+ The compiler __cannot__ save you from accidental type errors (This notion of safety is an illusion).
    * Any language that allows casting a variable into a new type is vulnerable.

_______________________________________________________________________________

# Chapter 6 - Acquiring Behavior Through Inheritance
>Inheritance is for __specialization__, NOT for sharing code.

## Understanding Classical Inheritance
_Classical_: Inheritance of classes
> No matter how complicated the code, the receiving object ultimately handles any message in one of two ways. It either responds directly or it passes the message on to some other object for a response.

+ Defines a forwarding path for non-understood messages.

## Recognizing Where to Use Inheritance
__(Recognizing when you have a problem that inheritance solves)__

__The problem that inheritance solves:__ highly related types that share common behavior but differ along some dimension (single class with several different but related types)

Here is a typical progression for problems that inheritance solves:

+ __1) Your code starts with a Concrete Class__
    * [Here is an example of a Concrete Bicycle Class](code_examples/chapter_6.rb#L2-L29).
    
+ __2) Then you start embedding multiple types into that Class__
    *  [Here is an example of the Bicycle Class with the embedded road style bike](code_examples/chapter_6.rb#L32-L68).
    *  Objects holding onto an instance of Bicycle may be tempted to check style before sending a message (creating a dependency).
    *  [Spot the Antipattern](code_examples/chapter_6.rb#L46-L54): _an if statetment that checks an attribute that holds the category of self to determine what message to send to self._
        -  __This pattern indicates a missing subclass.__

+ __3) Then you find the embedded types in your class__
    *  Be on the lookout for variables/attributes that denote different types. Typical names for these variables are: _type, category, style_

__Some extra details about inheritance__

+ __Multiple Inheritance:__ Gets complicated quickly. Ruby does NOT do this.
+ __Single Inheritance:__ a _subclass_ is only allowed one parent superclass (Ruby does this).
+ _Duck Types_ cut across classes. They __do not__ use classical inheritance; they share common behavior via __Ruby modules__.
<!-- WIP: add link to Chapter 7 -->
+ _Subclasses_ are __specializations__ of their _Superclasses_.

## Misapplying Inheritance
>__You should never inherit from a concrete Class. Always inherit from abstract Classes.__

__Abstract Class:__ disassociated from any specific instance.
[Wrong Code Example](code_examples/chapter_6.rb#L70-L98)
<img src="/images/ch6_1_misapplying_inheritance.png" width="400"/>

## Properly Applying Inheritance
__(Finding the Abstraction)__

> _Subclasses_ are everything their _Superclasses_ are, __plus more__.
> Any object that expect _Bicycle_ should be able to interact with a _Mountain Bike_ in blissful ignorance of its actual Class.

__Two things are required for inheritance to work:__

1. There is a _generalization-specialization_ relationship in the objects you are modelling.
2. Correct coding techniques are used.

__Here is a typical process on how to build a proper inheritance strategy:__

 + __1) Creating an Abstract Superclass and Pushing Down Everything to a Concrete Class__
     * __Abstract Superclass:__ Disassociated from any specific instance.
         - e.g You won't expect to have instances of _Bicycle_
     * Try to postpone the design of the inheritance until you are required to handle 3+ specializations. 
         - _e.g Until you are asked to deal with 3+ types of bikes._
         - Two: wait if you can. Three: will help you find the right abstraction.
         - It almost never makes sense to create an abstract superclass with only 1 subclass.
     * __Push down all__ code from the original class with mixed types (soon your __abstract superclass__) into one of the concrete classes.
         - [Pushing down all code to one concrete class](code_examples/chapter_6.rb#L100-L113) will probably [break the other concrete class.](code_examples/chapter_6.rb#L116-L128) This will be fixed next.
         - Result of this step:

<img src="/images/ch6_2_push_down_everything.png" height="150"/>

+ __2) Promoting abstract behavior while separating the abstract from the concrete__
    * Identify behavior that is common to all specializations and __promote__ it to the __abstract superclass.__ [Example of promotion](code_examples/chapter_6.rb#L181-L211)
        - This could even requiere splitting methods that have both abstract and concrete behavior inside.
            + [On this example](code_examples/chapter_6.rb#L277-L284) _spares_ is a candidate for promotion but it _tape color_ is only applicable for the _RoadBike_ specialization. Hence, [we need to separate it](code_examples/chapter_6.rb#L287-L296) and promote only the abstract (shared code).
    * Why push down and then promote?
        - Consequences of promotion failures are low.
        - Consequences of wrong demotion (leaving concrete code on the superclass) are high and difficult to solve.

+ __3) Invite Inheritors to Supply Specializations Using the Template Method Pattern__
    * _Template method pattern_ is a technique where a _superclass_ implements and calls methods that can be overriden by the _subclasses_ to supply specialized behaviour by implementing them.
        - [Bicycle's initilize method relies on the default_chain and default_tire_size](code_examples/chapter_6.rb#L299-L341) methods. Any specialization can implement those methods to set their own defaults.
        - [Another example of specialization with the template method pattern](code_examples/chapter_6.rb#L519-L541) with the _post\_initialize_ method.
    * __Avoid problems downstream by implementing and documenting every template method__
        - On [this example](code_examples/chapter_6.rb#L344-L352) the _Bicycle superclass_ hasn't implemented the _default tire size_ method. A programmer is asked to create a new specialization subclass (_RecumbentBike_) but he expects _Bicycle's default tire size_ method to hande the default.  As the method is not implemented anywhere and it is not documented with a useful error, a cryptic error is raised.
        - Any _superclass_ that uses the template method pattern must supply an implementation for every message it sends. [Even if the implementation is rasing a useful error that documents the pattern.](code_examples/chapter_6.rb#L371-L383)
  
## Managing Coupling Between Superclasses and Subclasses

>Abstract superclasses use the template method pattern to invite inheritors to supply specializations, and use hook methods to allow these inheritors to contribute these specializations without being forced to send super.

The way to manage coupling is illustrated using the implementation of the _spares_ method as example. Two implementations will be shown: 

+ (1) Coupled solution using __super__ (wrong)
+ (2) Decoupled solution using __hooks__ (right).

### Understanding Coupling
__(Coupled approach using super - Wrong)__

Take a look at [this solution](code_examples/chapter_6.rb#L412-L468) and notice the following:

+ _Subclasses_ rely on _super_.
    * This means the _subclass_ knows the algorithm. It depends on this knowledge.
+ Both _Subclasses_ know things their _superclass_.
    * They know that their _superclass_ responds to _initialize_. (They send _super_ on their initialize methods).
    * They know that their _superclass_ implements _spares_ and that it returns a hash.
+ Pattern: know things about themselves and about their _superclass_
    * This pattern requires that _sublasses_ know how to interact with their _superclasses_.
    * Forcing a subclass to know how to interact with their _superclass_ [can cause many problems](code_examples/chapter_6.rb#L491-L517)
    
### Decoupling Subclasses Using Hook Messages
__(Decoupled approach using hooks - Right)__

> Control should be on the _Superclass_, NOT the _Subclasses_

+ [Hook Example 1 - post_initialize](code_examples/chapter_6.rb#L519-L541).
    * Removes the _initialize_ method completely from the _subclass._
    * Eliminates _super_.
+ [Hook Example 2 - local_spares](code_examples/chapter_6.rb#L597-L617).
    * _RoadBike_ no longer knows that _Bicycle_ implements a spares method.
    * Eliminates _super_.
+ [This is the final implementation of _Bicyle_ and its _Subclasses_](code_examples/chapter_6.rb#L679-L744) and [this is how easy it is to create a new _subclass_](code_examples/chapter_6.rb#L747-L772).

> Well-designed inheritance hierarchies are easy to extend with new subclasses, even for programmers who know very little about the application. 

_______________________________________________________________________________

# Chapter 7a - Sharing Role Behavior with Modules

__Classical inheritance__ is not the best solution strategy for all problems. Other inheritance strategies such as __sharing role behavior with modules__ may be handy in those cases. [Look here for some guidelines on when to use each strategy](#chapter-7c-writting-inheritable-code)

>Creation of a recumbent mountain bike subclass requires combining the qualities of two existing subclasses, something that inheritance cannot readily accommodate. Even more distressing is the fact that this failure illustrates just one of several ways in which inheritance can go wrong.

> The use of classical inheritance is optional; every problem that it solves can be solved another way.

## Understanding Roles

+ Roles are for __sharing behavior and/or some method names in the public interface__ among __unrelated objects__.
    * If objects share only some __public method names__, [Duck typing of method names](#chapter-5-reducing-costs-with-duck-typing) can be enough (no modules required).
    * If objects share the public method names and the __behaviour inside those methods__, you should organize that code in a __module__.
    * When objects begin to play a _role_ they enter in a relationship with the objects for whom they play the role 
        -  Using a role creates dependencies that need to be taken into account when deciding among design options.

__Here is a typical process to create a proper role strategy. The design strategy is improved incrementally:__

+ __1) Finding Roles__
    * [Duck types](#chapter-5-reducing-costs-with-duck-typing) are roles.
    * Roles often come in pairs (if there is a `Preparer` role, there will also be a `Preparable` role).
        - `Preparable`implements an interface with all methods that a `Preparer`might send to it.
+ __2) Check if Responsibilites are Right__ (Organizing Responsibilites)
    * This section shows an example of a __wrong__ decision of responsibilites to help you spot some anti-patterns. 
    * The following sequence diagram shows a __wrong__ organization of responsibilites: 
    
    <img src="/images/ch7_1_class_checking_anti_pattern.png" height="400"/>  

+ __3) Solving Bad Responsibilites__ (Removing Unnecessary Dependencies)
    * __3.1) Discovering the Schedulable Duck Type (Role)__
        - The following diagram proposes and improvement but still has some improvement opportunities.

    <img src="/images/ch7_2_targets_do_not_speak_for_themselves.png" height="300"/>  
    
    * __3.2) Letting Objects Speak for Themselves__ 
    
> Objects should manage themselves; they __should contain their own behavior__. If your interest is in object B, you should not be forced to know about object A if your only use of it is to find things out about B.

 Extreme example to illustrate the idea: 
> Imagine a StringUtils class that implements utility methods for managing strings. You can ask StringUtils if a string is empty by sending StringUtils.empty?(some_string), but __this you are involving a third party for something that String should be able to do alone.__

+ __4) There are 2 decisions to deal with when implementing role behavior with modules.__
    * __4.1) What the code does__ _(Writing the Concrete Code)_
        - Pick an arbitrary __concrete class__ (as opposed to an [abstract class](#choosing-dependency-direction)) and implement the duck
            -  i.e Type the duck directly into the concrete class. You will worry about _where the code lives_ later.
            -  [This code](code_examples/chapter_7.rb#L12-L39) and the following diagram show an example of writing the duck directly on the concrete class.

<img src="/images/ch7_3_one_target_speaks_for_itself.png" height="300"/> 

  * __4.2) Where the code lives__ _(Extracting the Abstraction)_
      - Bicycle is not the only thing that is _schedulable_. How to rearrange the code so that it can be shared among objects of __different classes__?
      - [This Code](code_examples/chapter_7.rb#L52-L72) shows how to extract the abstraction from the previous step into a module. 
          + Notice that:
              * The dependency on `Schedule` has been moved to the `Schedulable` module, isolating it.
              * The module implements the `lead_days`  __hook__ to follow the [template method pattern](#properly-applying-inheritance). The `lead_days` hook is [overridable by any _includer_](code_examples/chapter_7.rb#L75-L93) of the module.
                  - Just as with classical inheritance, modules must implement every __template method pattern__ (even if it only raises an error).
              * [Other objects can play the `Schedulable` role by including the module without duplicating the code](code_examples/chapter_7.rb#L96-L127). The current implemantation looks as follows:

<img src="/images/ch7_4_the_schedulable_duck_type.png" height="300"/> 
_______________________________________________________________________________

# Chapter 7b - How does Ruby Method Look-Up Works? 
__(Looking Up Methods)__

<img src="/images/ch7_7_method_lookup.png" height="500"/> 

__Include vs Extend__

+ __Include:__ affects all instances of the class where the module was included (behave like instance methods).
+ __Extend:__ adds the module's behavior directly into the __single object__.
    * __Extending a class__ with a module creates __class methods__ (A class is an object).
    * __Extending an instance__ of a class with a module creates instance methods in __that instance__.

__How missing methods are handled in Ruby__ 
>If all attempts to find a suitable method fail, you might expect the search to stop, but many languages make a second attempt to resolve the message.

>Ruby gives the original receiver a second chance by sending it new message, method_missing, and passing :spares as an argument. Attempts to resolve this new message restart the search along the same path, except now the search is for method_missing rather than spares.

_______________________________________________________________________________

# Chapter 7c - Writting Inheritable Code
__Applies for [Chapter 5](#chapter-5-reducing-costs-with-duck-typing), [Chapter 6](#chapter-6-acquiring-behavior-through-inheritance) and [Chapter 7.1](#chapter-7a-sharing-role-behavior-with-modules)__

With classical inheritance and sharing roles with modules you can write very convoluted and difficult to debug code. The intention of this chapter is to show you the specific __coding techniques__ used to write quality inheritance strategies.

## Coding Technique 1: Recognize the Antipatterns

+ __Antipattern 1:__ objects that use variable names like `type` or `category` to determine what message to send to `self`
    * Solution: [Classican Inheritance](#chapter-6-acquiring-behavior-through-inheritance)
+ __Antipattern 2:__ when a sending object checks the type of the receiving object to determine what message to send.
    * You have overlooked a duck type.
    * Solution: Implement a duck type interface on all recieving objects.
        - If duck types also share behaviour (not only the interface), place that code [in a module](#chapter-7a-sharing-role-behavior-with-modules) and include it on every duck.
+ Extra info: When choosing between classical inheritance or roles (duck types) think about this:
    * _is-a_ (classical) versus _behaves-like-a_ (roles)

## Coding Technique 2: Insist on the Abstraction

+ __Rule:__ All of the code in an abstract superclass should apply to every class that inherits it / The code in a module must apply to all who use it.
+ __Consequences of breaking the rule:__ inheriting objects obtain incorrect behaviour. Programmes start to do awful hacks to get around this weird behaviour.
+ __Symptoms of breaking the rule:__ Subclasses or objects that include a module that override a method to raise an exception like _'does not implements this method'_.
+ __Common pitfalls when working with abstractions:__
    * Creating an abstraction where it doesn't exist. (If you cannot indentify it correctly, there may not be one.)
    * If no common abstraction exists, then inheritance is not the solution to the problem.

## Coding Technique 3: Good Practices on Superclasses & Subclasses
__(Honor the Contract)__

Contract: All `Subclasses` must be suitable to substitute their `Superclass` without breaking anything.

__Subclasses must:__

+ Conform to their `Superclass` interface
    * Respond to every message in that interface, taking the same kinds of inputs and returning the same kind of outputs.
+ They are not permitted to do anything that forces others to check their type in order to know how to treat them.

## Coding Technique 4: Use the Template Method Pattern
[See _Properly Applying Inheritance_ for more information.](#properly-applying-inheritance)

## Coding Technique 5: Preemptively Decouple Classes

> Avoid writing code that requires its inheritors to send super; instead use hook messages to allow subclasses to participate while absolving them of responsibility for knowing the abstract algorithm.

See [Decoupling Subclasses Using Hook Messages](#decoupling-subclasses-using-hook-messages)

__Warning:__ Hook methods only solve the problem of sending `super` for adjacent levels of the hierarchy. That is why coding technique is important.

## Coding Technique 6: Create Shallow Hierarchies
<img src="/images/ch7_8_shapes_of_hierarchies.png" height="300"/> 
_______________________________________________________________________________

# Chapter 8.1 - Combining Objects with Composition

>Combining different parts into a complex whole such that te whole becomes more than the sum of it's parts.

>In composition the larger object is connected to its parts via a _has-a_ relationship (A Bicycle has parts). __Part__ is a role and bicycles are happy to collaborate with any object that plays the role.

__This chapter shows how to replace gradually an inheritance design with composition.__

## Step 1) Compose `Parts` into a Bicycle

+ If you create an object to hold all of a bicycle's parts (i.e a `Parts` object), you could delegate the spares message to that new object ([See this line of code](code_examples/chapter_8.rb#L10)). 
+  [This code](code_examples/chapter_8.rb#L2-L13) shows how to turn a Bicycle into a composed object.
    *  Bicycle is now responsible for 3 things: knowing it's size, holding on to it's `Parts` and answering spares.

## Step 2) Moving the parts logic into the `Parts`class

+ [This first coding approach](code_examples/chapter_8.rb#L16-L79) is temporal as it still relies on inheritance to work.
+ Pros: made obvious how little `Bicycle` specific code there was.
+ Cons: still uses inheritance for the specialization of `Parts`.
+ The following diagram depicts the design strategy up to this point.

<img src="/images/ch8_1_step_2_design.png" height="220"/> 

## Step 3) Composing the `Parts`object with `Part`objects

>There will be a `Parts` object and it will contain many `Part` objects.

The following diagram illustrates the final strategy that is going to get built. Notice that inheritance dissappears. 

<img src="/images/ch8_1_step_3_final_design.png" height="450"/> 

### Step 3.1) Creating a `Part` object
[This code](code_examples/chapter_8.rb#L107-L140) shows the creation of the new `Part` class and the corresponding refactor on the `Parts` class.

[Here](code_examples/chapter_8.rb#L143-L204) you can see how the previous code can be used to create `Part` objects, sets of  `Part` objects for each bicycle configuration and `Bicycle` objects.

__Avoid this pitfall__

> While it may be tempting to think of these objects as instances of `Part`, composition tells you to think of them as objects that play the `Part` role. They don’t have to be a kind-of the `Part` class, they just have to act like one; that is, they must respond to `name`, `description`, and `needs_spare`.

 + Cons:
     * The `Bicycle`'s methods `spares` and `parts` behave weird because they return different sort of things.
     
     ```ruby
     mountain_bike.spares # returns an array of Part objects
     mountain_bike.parts # returns a Parts object
     ```

     * This causes [weird behaviour](code_examples/chapter_8.rb#L207-L210) when using them.

### Step 3.2) Making the `Parts` Object More Like an Array

__This chapter will explore 4 different approaches to deal with the aforementioned weird behavior.__

+ __Approach 1: Leave as is and accept the lack of array-like behavior__
    * Pros: As simple as it gets.
    * Cons: Limited use.
    
+ __Approach 2: Emulate the array-like behavior that is needed by [adding methods to the `Parts` Class](code_examples/chapter_8.rb#L213-L215)__
    * Pros: Simple solution if you need limited array-like behavior.
    * Cons: Slippery slope path. Soon you will be adding `each` and `sort` (and more array behavior).
    
+ __Approach 3: [Subclass Array](code_examples/chapter_8.rb#L218-L222)__
    * Pros: Straight forward solution that adds all array-like behavior.
        - Use this if you are certain that you will never encounter confusing errors.
    * Cons: [Confusing errors](code_examples/chapter_8.rb#L225-L241) can arise from `Array` methods that return arrays instead of the subclassed `Parts` object.
        - Many methods in the `Àrray` class return arrays.
        - In __approach 1__ a `Parts` object could not respond to `size`.  In this approach the addition of to `Parts` objects cannot respond to `spares`.
        
+ __Approach 4: [Use Delegation and Enumerable](code_examples/chapter_8.rb#L244-L257)__
    * __Forwardable:__ is a ruby module that allows you to forward a message to a designated object. [More info in the Ruby Doc.](http://ruby-doc.org/stdlib-2.0.0/libdoc/forwardable/rdoc/Forwardable.html)
        - For example, `def_delegators :@parts, :size, :each` means that whenever `size` or `each` is sent to a `Parts` object,  the message will be forwared to it's `@parts` (i.e `@parts.size` and `@parts.each`).
        - Classes are usually [extended](#chapter-7b-how-does-ruby-method-look-up-works) with `Forwardable`.
    * __Enumerable:__ is a ruby module that when mixed into a collection class, provides it's instances (e.g a `Parts` object) __several transversal, searching and sorting methods.__ [More info in the Ruby Doc](http://ruby-doc.org/core-2.3.1/Enumerable.html) or on [this link.](https://www.sitepoint.com/guide-ruby-collections-iii-enumerable-enumerator/)
        - Enumerable is usually [included](#chapter-7b-how-does-ruby-method-look-up-works) into collection classes (e.g the `Parts` class).
        - The class that includes `Enumerable` must implement an `each` that yields successive members of the collection.
        - On this example `each` in the `Parts` class is 'implemented' by forwarding it to it's `@parts` attribute.
    * [This example](code_examples/chapter_8.rb#L322-L331) shows that both `spares` and a `Parts` object respond to `size`.
    * Pros: 
        -  Middle ground between complexity and usability.
        -  Responds to all `Enumerable` methods.
        -  [Raises errors when a `Parts` object is treated like an array.](code_examples/chapter_8.rb#L334-L336)
    * Cons:
        - The code may be complex for new developers.

## Step 4) Manufacturing Parts (with Factories)
__Problem__
Look at  [these lines](code_examples/chapter_8.rb#L332-L335). These 4 lines represent a big __knowledge dependency__ on how to create the appropiate `Part` objects for a specific Bicycle. This dependency can spread through your app.

__The solution is given incrementally on the following steps.__

### Step 4.1) There are only a few valid combination of `Part` objects. [Centralize that knowledge in one place](code_examples/chapter_8.rb#L339-L348).

### Step 4.2) Create the `PartsFactory`
__A _factory_ is an object whose only purpose is to manufacture other objects.__

> [This code](code_examples/chapter_8.rb#L351-L363) shows a new PartsFactory module. Its job is to take an array like one of those listed above and manufacture a Parts object. Along the way it may well create Part objects, but this action is private. Its public responsibility is to create a Parts. 

+ The factory takes 3 arguments: 
    *  1) [Config array](#step-41-there-are-only-a-few-valid-combination-of-part-objects-centralize-that-knowledge-in-one-place)
    *  2 & 3) Name of the classes to be used for creating `Part` objects and the `Parts` object.
+  __Pros:__
    *  Creating a `Parts` object with proper configuration for a specific bike [is easy](code_examples/chapter_8.rb#L366-L375).
    *  Your knowledge is centralized. You should __always__ new `Parts` objects using the factory.
+  __Cons:__
    *  Although all the code up to this point __works perfectly,__ the `Part` class [has become so simple](code_examples/chapter_8.rb#L385-L393) after all this refactoring that it may not be necessary at all.

### Step 4.2) Leveraging the `PartsFactory` to remove the `Part` class
> If the `PartsFactory` created every part, the `Part` class would not be necessary. This would simplify the code.

+ The `Part` class can be replaced by an `OpenStruct`.
    * `OpenStruct` is a lot like `Struct`. It provides a convenient way to bundle a number of attributes into an object (without creatin a class).
        - `OpenStruct` takes a hash for initialization while `Struct` takes position order initialiation arguments.
+ [This code](code_examples/chapter_8.rb#L396-L410) shows a refactored version of the `PartsFactory` where the `Part` creation was moved into the factory using `OpenStruct` and the `Part` class was deleted.
    *  [This code](code_examples/chapter_8.rb#L408) is the only place in the app where `need_spares` defaults to true.
    *  The `PartsFactory` should be the __only responsible__ for manufacturing `Parts`.
    *  [Here is how this version of the factory works](code_examples/chapter_8.rb#L413-L421).

### Step 5) Wrapping Up- The Composed Bicycle Overview
This section shows how all the code written from step 1 to step 4 works together. No new code is introduced.

+ [This 54 lines of code](code_examples/chapter_8.rb#L423-L476) replace the 66 lines required for the inheritance strategy.  Important thinks to keep in mind:
    * `Bicycle` _has-a_ `Parts`, which in turns `has-a` collection of `Part` objects.
    * `Parts` and `Part` may exist as classes. However the important thing is that someone plays the `Parts` and `Part` __role (think of them as roles).__
        - In this example `Parts` class plays the `Parts`role (it implements spares.) The role of `Part` is played by an `OpenStruct`(implements `name, description` and `need_spares`).
+ [Here is how you use this code to create a specific type of bike](code_examples/chapter_8.rb#L479-L494).
+ [Here is how you create a completely new type of bike (with 3 lines!)](code_examples/chapter_8.rb#L496-L519).
    * __You only need to describe the new type of bike's parts__

# Chapter 8.2 - Composition vs Inheritance

# Chapter 8.3 - Tips on how to choose between design strategies
__Applies for chapters 5 through 8.__
