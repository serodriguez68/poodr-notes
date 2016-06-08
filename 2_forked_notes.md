#### Chapter 1 - Object Oriented Design
The purpose of design is to allow you to do design later, and it's primary goal is to reduce the cost of change.

[SOLID Design](http://en.wikipedia.org/wiki/SOLID_(object-oriented_design)):

* Single Responsibility Principle: a class should have only a single responsibility
* Open-Closed Principle: Software entities should be open for extension, but closed for modification (inherit instead of modifying existing classes).
* Liskov Substitution: Objects in a program should be replaceable with instances of their subtypes without altering the correctness of that program.
* Interface Segregation: Many client-specific interfaces are better than one general-purpose interface.
* Dependency Inversion: Depend upon Abstractions. Do not depend upon concretions. See [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_Injection)

Other principles include:
* Do Not Repeat Yourself: Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
* Law of Demeter: A given object should assume as little as possible about the structure or properties of anything else.

#### Chapter 2 - Designing Classes with a Single Responsibility
>A class should do the smallest possible useful thing.

>Applications that are easy to change consist of classes that are easy to resue.

>How can you determine if the `Gear` class contains behavior that belongs somewhere else? One way is to pretend that it's sentient and to interrogate it. If you rephrase every one of it's methods as a question, asking the question ought to make sense. For example, asking "Gear, what is your ratio?" seems perfectly reasonable..."Gear, what is your tire size?" is just downright ridiculous.

**Depend On Behavior, Not Data**

Hide instance variables. [[Code example](https://github.com/skmetz/poodr/blob/master/chapter_2.rb#L61)]

Hide data structures. [[Code example](https://github.com/skmetz/poodr/blob/master/chapter_2.rb#L123)]

#### Chapter 3 - Managing Dependencies
>An object depends on another object if, when one object changes, the other might be forced to change in turn.

**Recognizing Dependencies**

An object has a dependency when it knows:
* The name of another class
* The name of a message that it intends to send to someone other than `self` (methods on other objects).
* The arguments that a message requires.
* The order of those arguments.

>Your design challenge is to manage dependencies so that each class has the fewest possible; a class should know just enough to do it's job and not one thing more.

The more one class knows about another, the more tightly it is <i>coupled</i>.

>Test-to-code over-coupling has the same consequence as code-to-code over-coupling.

Factory: an object whose purpose is to create other objects.

>Depend on things that change less often than you do.

* Some classes are more likely than others to have changes in requirements
* Concrete classes are more likely to change than abstract classes
* Changing a class that has many dependents will result in widespread consequences

Abstraction in Ruby = duck typing; depending on an interface (objects will respond to methods) rather than a concrete class implementation.

#### Chapter 4 - Creating Flexible Interfaces

>Domain objects are easy to find but they are not at the design center of your application. They are a trap for the unwary. If you fixate on domain objects you will tend to coerce behavior into them. Design experts notice domain objects without concentrating on them; they focus not on these objects but on the messages that pass between them.

Using a kitchen analogy: your objects should "order off a menu" instead of "cooking in the kitchen".

>This transition from class-based design to message-based design is a turning point in your design career.  The message-based perspective yields more flexible applications than does the class-based perspective. Changing the fundamental design question from "I know I need this class, what should it do?" to "I need to send this message, who should respond to it?" is the first step in that direction.

Ask for "what" instead of telling "how".

>You don't send messages because you have objects, you have objects because you send messages.

Context: the things that an object knows about other objects. Objects that have a simple context are easy to test, objects with a complicated context are more difficult to test.

The best possible situation is for an object to be completely independent of it's context (dependency injection). _I know what I want and I trust you to do your part._

**Law of Demeter**
>Only talk to your immediate neighbors

It's a "law" in the sense of a guideline, not a hard and fast rule.

>Balance the likelihood and cost of change against the cost of removing the violation.

>...Demeter is more subtle than it appears.  It's fixed rules are not an end in themselves; like every design principle, it exists _in service of_ your overall goals.  Certain "violations" of Demeter reduce your application's flexibility and maintainability, while others make perfect sense.

The problem with Demeter violations (like `customer.bicycle.wheel.rotate`) is that they show that code (`customer`) knows too much about how other code works. It's a manifestation of tight coupling.

>The train wrecks of Demeter violations are clues that there are objects whose public interfaces are lacking.

#### Chapter 5 - Reducing Costs with Duck Typing

Duck types = public interfaces not tied to any specific class

>It's not what an object _is_ that matters, it's what it _does_.

>Concrete code is easy to understand, but costly to extend. Abstract code may initially seem more obscure but, once understood, is far easier to change.

>Once you begin to treat your objects as if they are defined by their behavior rather than by their class, you enter a new realm of expressive design.

**Recognizing Hidden Ducks**

Case statements that switch on class, `kind_of?`, `is_a?`, and `responds_to?` are potential ducks.

####Chapter 6 - Acquiring Behavior Through Inheritance
>Inheritance is, at it's core, a mechanism for _automatic message delegation_. It defines a forward path for not-understood messages.

>Subclasses are _specializations_ of their superclasses

Everything the parent class is, plus more.

[Template Method pattern](http://en.wikipedia.org/wiki/Template_method_pattern)

>Any class that implements the template method pattern must supply an implementation for every message it sends, even if the only reasonable implementation in the sending class looks like:

```ruby
class Bicycle
  #...
  def default_tire_size
    raise NotImplementedError
  end
end
```

See https://github.com/skmetz/poodr/blob/master/chapter_6.rb#L358 for an example of refactoring a base class and two subclasses with the template method pattern

#### Chapter 7 - Sharing Role Behavior With Modules

Combining the qualities of two existing subclasses is something Ruby cannot do (multiple inheritance)

>Because no design technique is free, creating the most cost-effective application requires making informed tradeoffs between the relative cost and likely benefits of alternatives

Classical inheritance vs module inclusion can be thought of as _is a?_ vs _behaves like_.

**Method Lookup Flow**

* Including a module inserts it's method "above" it's superclass, in the object hierarchy.
* Therefore, if a method exists anywhere in the hierarchy between subclass and superclass, and also in an included module, the superclass method wins out.

>When a single class includes several different modules, the modules are placed in the method lookup path in the _reverse order_ of module inclusion. Thus, the methods of the last included module are encountered first in the lookup path.

<img src="http://cl.ly/image/0w0Z2b12273O/methodlookup.png" width="450"/>

_Note: Sandi mentions that the above image could in some cases be more complicated, but for most programmers it's ok to think of the object hierarchy in this way_

**Writing Inheritable Code**

* Recognize the antipatterns
* Insist on the abstraction
* Honor the contract (Liskov Substitution Principle)
* Use the template method pattern
* Preemptively decouple classes (avoid `super`)
* Create shallow hierarchies

>...when a sending object checks the class of a received object to determine what message to send, you have overlooked a duck type. This is another maintenance nightmare; the code must change everytime you introduce a new class of receiver. In this situation all of the possible receiving objects play a common role. They should be codified as a duck type and receivers should implement the duck type's interface. Once they do, the original object can send one single message to every receiver, confident that because each receiver plays the role it will understand the common message.

**Insist On The Abstraction**

>If you cannot correctly identify the abstraction there may not be one, and if no common abstraction exists then inheritance is not the solution to your design problem.

**Create Shallow Hierarchies**

Depth = number of superclasses between object and the top; breadth = number of it's subclasses. Prefer shallow & narrow.

<img src="http://cl.ly/image/3M1g000n201Y/shallow.png" width="450"/>

#### Chapter 8 - Combining Objects with Composition

`Forwardable` http://www.ruby-doc.org/stdlib-2.0/libdoc/forwardable/rdoc/Forwardable.html

>Composition describes a _has a_ relationship.

Composition: objects "inside" have no meaning outside that context

Aggregation: like composition except objects "inside" have meaning outside that context

**Deciding Between Inheritance and Composition**

Inheritance gives you message delegation for free at the cost of maintaining a class hierarchy.  Composition allows objects to have structural independence at the cost of explicit message delegation.

>Composition contains far few built-in dependencies than inheritance; it is very often the best choice.

With inheritance, a correctly modeled hierarchy will give you the benefit of propogating changes in the base class to all subclasses. This can also be a disadvantage when the hierarchy is modeled incorrectly, as a dramatic change to the base class due to a change in requirements will break sub-classes. Inheritance = built-in dependencies.

>Enormous, broad-reaching changes of behavior can be achieved with very small changes in code. This is true, for better or for worse, whether you come to regret it or not.

>Avoid writing frameworks that require users of your code to subclass your ibjects in order to gain your behavior. Their application's objects may already be arranged in a hierarchy; inheriting from your framework may not be possible.

#### Chapter 9 - Designing Cost-Effective Tests

3 Skills Needed to Write Changeable Code
* Understand OO design
* Skilled at [refactoring](http://refactoring.com/) code
* Ability to write high-value tests

>Changeability is the only design metric that matters; code that's easy to change _is_ well-designed.

>Good design preserves maximum flexibility at minimum by putting off decisions at every opportunity, deferring commitments until more specific requirements arrive. When that day comes, _refactoring_ is how you morph the current code structure into the one what will accommodate the new requirements.

Tests free you to refactor with impunity.

>The true purpose of testing, just like the true purpose of design, is to reduce costs.

**Intentional Testing**

Benefits of testing
* Finding bugs
* Supplying documentation ("Tests provide the only reliable documentation of design.")
* Deferring design decisions ("When your tests depend on interfaces you can refactor the underlying code with reckless abandon.")
* Supporting abstractions
* Exposing design flaws

**Knowing What to Test**

>Most programmers write too many tests...One simple way to get better value from tests is to write fewer of them.

>Dealing with objects as if they are only and exactly the messages to which they respond lets you design a changeable application, and it is your understanding of the importance of this perspective that allows you to create tests that provide maximum benefit at minimum cost.

>Here, then, are guidelines for what to test: Incoming messages should be tested for the state they return. Outgoing command messages should be tested to ensure they get sent. Outgoing query messages should not be tested.

**Knowing When to Test**

First, obviously.

>Tests are reuse.

>Your application is improved by ruthlessly eliminating code that is not actively being used.

>Freeing your imagination from an attachment to the class of the incoming object opens design _and testing_ possibilities that are otherwise unavailable.

