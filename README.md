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
    * __ Follow__ Agile, __NOT__ Big Up Front Design (BUFD)

### When to Design
* __Do__ Agile Software development.
* __Don't do__ Big Up Front Design (BUFD).
    * Designs in BUFD cannot possibly be correct as many things will change during the act of programming.
    * BUFD inevitable leads to an adversarial relationship between customers and programmers.
* Make design decisions only when you must with the information you have at that time (don't make decisions prematurely).

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
* A class __must__ have __data__ and __behaviour__ (methods).  If one of these is missing, the code doesn't belong to a class.

### Determining if a class has a single responsibility
* __Technique 1: Ask questions for each of it's methods.__
    * _"Please Mr. Gear, what is your ratio?"_ - Makes sense = ok
    * _"Please Mr. Gear, what is your tire size?"_ - Doesn't make sense = does not belong here
* __Technique 2: Describe the class in one sentence.__
    * The description contains the words _"and"_ or _"or"_ = the class has more than one responsibility
    * If the description is concise but the class does much more than the description = the class is doing too much
    * Example: _"Calculate the effect that a gear has on a bicycle"_

## Writing Code that Embraces Change

### Depend on behaviour (methods), Not Data

#### Hide Instance Variables
Never call @variables inside methods = user wrapper methods instead. 
[Wrong Code Example](code_examples/chapter_2.rb#L61-71) / [Right Code Example](code_examples/chapter_2.rb#L73-102)

#### Hide Data Structures
If the class uses complex data structures = Write wrapper methods that decipher the structure and depend on those methods.
[Wrong Code Example](code_examples/chapter_2.rb#L105-117) / [Right Code Example](code_examples/chapter_2.rb#L124-141)
