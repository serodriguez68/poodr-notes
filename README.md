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
[Wrong Code Example](code_examples/chapter_2.rb#L61-71) / [Right Code Example](code_examples/chapter_2.rb#L73-102)

#### Hide Data Structures
If the class uses complex data structures = Write wrapper methods that decipher the structure and depend on those methods.
[Wrong Code Example](code_examples/chapter_2.rb#L105-117) / [Right Code Example](code_examples/chapter_2.rb#L124-141)

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
If you are not sure if you will need another class but have identified a class with an extra responsibility, __isolate it__ ([Example using Struct.](code_examples/chapter_2.rb#L176-197))
_______________________________________________________________________________
# Chapter 3 - Managing Dependencies
## Recognizing Dependencies
An object has a dependency when it knows ([See example code](code_examples/chapter_3.rb#L2-34)): 

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
[Wrong Code Example](code_examples/chapter_3.rb#L37-52) / [Right Code Example](code_examples/chapter_3.rb#L55-67)

### Isolate Instance Creation
Use this if you can't get rid of "_the name of another class_" dependency type through dependency injection.

+ Technique 1: __Move external class name call to the initialize method.__ ([Example code](code_examples/chapter_3.rb#L73-83))
+ Technique 2: __Isolate external class call in explicit defined method.__ ([Example code](code_examples/chapter_3.rb#L87-102))

### Isolate Vulnerable External Messages
> For messages sent to someone other than _self_.

Not every external method is a candidate for isolation. External methods become candidates when the dependency becomes dangerous. For example:

+ The external method is buried inside other complex code.
+ There are multiple calls to the external methods inside the class.
+ The method is part of the [private interface of another class.](#r3-exercise-caution-when-depending-on-private-interfaces)

[Wrong Code Example](code_examples/chapter_3.rb#L111-115) / [Right Code Example](code_examples/chapter_3.rb#L118-126)

### Use Hashes for Initialization Arguments
+ You will be changing the argument order dependency for an argument name dependency.
    * Not a problem: argument name is more stable and provides explicit documentation of arguments.
+ The use of these technique depends on the case:
    * For very simple methods you are better off accepting the argument order dependency.
    * For complex method signatures, hashes are best.
    * There are many cases in between where some arguments are required as stable (dependent on order) and some are less stable or optional (dependent on names by hash).  This is fine.

[Wrong Code Example](code_examples/chapter_3.rb#L129-142) / [Right Code Example](code_examples/chapter_3.rb#L145-158)

### Explicitly Define Defaults
+ __Simple non-boolean defaults:__ '_||_' ([Code Sample](code_examples/chapter_3.rb#L161-166))
    * Problem: you can't set an attribute to _nil_ or _false_ because the fallback value will take over.
+ __Hash as argument with simple defaults:__ _fetch_ ([Code Sample](code_examples/chapter_3.rb#L169-174))
    * _Fetch_ depends on the __existence__ of the key.  If the key is not present, it returns the fallback value.
        - This means that attributes can be set to _nil_ and _false_, without the fallback value taking over.
+ __Hash as argument with complex defaults:__ _defaults method + merge_ ([Code Sample](code_examples/chapter_3.rb#L177-186))
    * The _defaults_ method is an independent method that handles the complex logic for defaults and returns a hash.  This hash is then merged to the actual _arguments hash_.

### Isolate Multiparameter Initialization 
For methods where you can't change the order of arguments (e.g external interfaces).

+ Wrap the external interface in a _module_ whose sole purpose is to create objects from the external dependency. ([Code Sample](code_examples/chapter_3.rb#L189-209))
    * FYI: objects whose purpose is to create other objects are called _factories_.
+  Use a _module_, __not__ a Class because you don't expect to create instances of the module.

### Reversing dependencies
Imagine the case where _KlassA_ depends on _KlassB_. This is where _KlassA_ instantiates _KlassB_ or calls methods from _KlassB_.

You could write a version of the code were _KlassB_ depends con _KlassA_.
[Gear depends on Wheel Sample](code_examples/chapter_3.rb#L2-34) / [Wheel depends on Gear Sample](code_examples/chapter_3.rb#L264-300) 

#### Choosing Dependency Direction
> Depend on things that change less often than you do.

+ Some classes are more likely than others to have changes in requirements.
    * You can rank the likelihood of change of any classes you are using regardless of their origin (internal or external). This will help you to make decisions.
+ Concrete classes are more likely to change than abstract classes.
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
>On a restaurant the kitchen does many things but does not, expose them all to its customers. It has a __public__ interface that customers are expected to use; the menu. Within the kitchen many things happen, many other messages get passed, but these messages are __private__ and thus invisible to customers. Even though they may have ordered it, customers are not welcome to come in and stir the soup.

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

The definition _"only use one dot"_ is not always right. There are cases that use multiple dots that do not violate Demeter.

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
+ Demeter violations are clues of missing public interfaces. 
+ It is easy to comply with Demeter if you use a __message-based perspective__ in your design.





