#import "../index.typ": (
  notes-info, notes-item, notes-side-info, page-source, template, tufted,
)
#import "@preview/cmarker:0.1.8"
#show: template.with(title: "Rust for C/C++ Programmers :: Johan Xie")

#let this-book-url = "https://microsoft.github.io/RustTraining/c-cpp-book/"
#let this-book-link(path, body) = link(this-book-url + path)[#body]

#page-source

= Rust for C/C++ Programmers

This is an #link("https://microsoft.github.io/RustTraining/c-cpp-book/")[online
  book by Microsoft] to enable C/C++ programmers self-study Rust in a few days.

#notes-side-info(
  updated-date: datetime(year: 2026, month: 4, day: 5),
  created-date: datetime(year: 2026, month: 3, day: 28),
)

= Part I: Foundations

#tufted.margin-note[
  *Suggested Time*: 1 day \
  *Checkpoint*: You can write a CLI temperature converter \
  *Start to End*: 2026-03-28
]

== Day 1: Setup, types, control flow (Chapters 1-4)

*Chapter 1: Introduction and Motivation*

Good:

- Resources management - No rule of five
- Forbid modification of a collection while iterating over it - No invalid
  iterator
- Prevent data races at compile time through `Send` and `Sync` traits.
- No use-after-move.
- No uninitialized variables.
- `Mutex<T>` wraps the data, not the access; Lock guards are the _only_ way to
  access the data.

*Chapter 2: Getting Started*

What is a crate?

#let package-and-crate-link = "https://doc.rust-lang.org/book/ch07-01-packages-and-crates.html"
- #link(package-and-crate-link)[Packages and Crates - The Rust Programming
    Language]:

  #quote[
    A _crate_ is the smallest amount of code that the Rust compiler considers
    at a time. ... Crates can contain modules...

    A crate can come in one of two forms: a binary crate or a library crate.

    A _packcage_ is a bundle of one or more crates that provides a set of
    functionality. A package contains a _Cargo.toml_ file that describes how to
    build those crates.

    A package can contain as many binary crates as you like, but at most only
    one library crate.
  ]

- Commonly, a repository (like a GitHub repository) can contain multiple
  packages at a time. Each directory under the repository root contains
  a _Cargo.toml_ file.

*Chapter 3: Built-in Types*

Rust variable are *immutable* by default (a bit like *by default const* in
C/C++, but not actually the same).

*Chapter 4: Control Flow*

`if` is an expression (used as in C/C++ `cond ? yes : no` ternary operator).

```plaintext
// C/C++
int a = condition ? 1 : 0;
// Rust
let a = if condition {1} else {0};
```

`loop` creates an infinite loop until a `break` is encountered (just like `for
(;;) {}`, but `break value;` in Rust can be considered the value of the `loop`
expression, and `loop` can be used with labels).

The last expression (without `;`, instead of statement) of a block is the return
value of the block. This is used to omit the `return` keyword in functions.

#tufted.margin-note[*Checkpoint*: You can write a CLI temperature converter]

*Checkpoint callback*

```rust
// cli_temperature_converter.rs
fn celsius_to_fahrenheit(c: f32) -> f32 {
    1.8f32 * c + 32f32
}

fn fahrenheit_to_celsius(f: f32) -> f32 {
    (f - 32f32) / 1.8f32
}

fn main() {
  let c = 32;
  let f_from_c = celsius_to_fahrenheit(c);
  println!("celsius {c} -> fahrenheit {f_from_c}");

  let f = 32;
  let c_from_f = fahrenheit_to_celsius(f);
  println!("fahrenheit {f} -> celsius {c_from_f}");
}
```

#tufted.margin-note[
  *Suggested Time*: 1-2 days \
  *Checkpoint*: You can explain why `let s2 = s1` invalidates `s1` \
  *Start to End*: 2026-03-29
]

== Day 2: Data structures (Chapters 5-7)

*Chapter 5: Data Structures*

Arrays have compile-time determined length, just like C without VLA. But it can
be initialized with non const values, such as random values:

```rust
use rand::prelude::*;

fn main() {
    let num: u8 = rand::random();
    let array: [u8; 2] = [num, num];
    println!("{:?}", array);
}
```

Tuples have a fixed size.

References: 1 mutable or (this is an exclusive or) multiple immutables;
references cannot outlive the variable scope (so no dangling pointer issue).

Slices are used to create subsets of arrays (a bit like `string_view` but in
a more general sense). Internally, slices are implemented as _fat pointers_ that
contains the length of the slice and a pointer to the starting element in the
original array. To mimic that in C:

```c
struct slice {
    void *ptr;
    size_t len;
};
```

Constants (with `const` keyword) are evaluated at compile time (just like in C).

Statics (with `static` keyword) are used to define the equivalent of global
variables (also like in C). They are created once and last the entire lifetime
of the program.

*Strings*: two major types, and no null terminator (`\0`)

- `String` is a heap-allocated, growable string (like in C `malloc`ed `char *`
  buffer, or in C++ `std::string`).
- `&str` is a immutably borrowed reference (like a custom string view in C with
  `const char *`, or a `string_view` in C++ but with lifetime check, so
  guaranteed to be valid and never dangle).

*Why Strings are not indexable with `[]`*

- Because they are in unicode (UTF-8), not bytes
- Because you need to deal with concepts like code points and graphemes. It
  would be better/safer to use `.chars()` char iterator or `.as_bytes()` raw
  bytes or even `&[..]` slices (to produce `&str`).

*Exercises*

- Write a function `fn count_words(text: &str) -> usize` that counts the number
  of whitespace-separated words in a string

  *Answer*:

  ```rust
  fn count_words(text: &str) -> usize {
      text.split_whitespace(" ").count()
  }
  ```

- Write a function `fn longest_word(text: &str) -> &str` that returns the
  longest word (hint: you’ll need to think about lifetimes – why does the return
  type need to be `&str` and not `String`?)

  The return type could be `String` but it allocates memory on heap, while it
  should not, as it is in fact finding the starting position of the longest word
  in a guaranteed-to-be-valid string (`&str`) and the length of the word.

  *Answer*:

  ```rust
  fn longest_word(text: &str) -> &str {
      text.split_whitespace()
          .max_by_key(|word| word.len())
          .unwrap_or("")
  }
  ```

Structs using `struct`. Struct members can be anonymous: tuple structs. Tuple
structs are similar to "_typedef_" tuples.

- A common use case for tuple structs: wrap primitive types to create custom
  types, so as to *avoid mixing differing values of the same type*.
- *Hint*: `#[derive(Debug)]` is helpful for debug printing.

`Vec<T>` represents a dynamic heap allocated buffer (like `malloc`ed/`realloc`ed
`T*` in C, or `std::vector<T>` in C++)

`HashMap` implements a hash map (like in C++ `std::unordered_map`)

*Exercises*

- Create a `HashMap<u32, bool>` with a few entries (make sure that some values
  are `true` and others are `false`). Loop over all elements in the hashmap and
  put the keys into one `Vec` and the values into another

  *Answer*:

  ```rust
  use std::collections::HashMap;

  fn main() {
      let mut map: HashMap<u32, bool> = HashMap::new();
      map.insert(1u32, true);
      map.insert(2u32, false);
      let mut keys: Vec<u32> = vec![];
      let mut values: Vec<bool> = vec![];
      for (k, v) in &map {
          keys.push(*k);
          values.push(*v);
      }
      println!("{keys:?}");
      println!("{values:?}");

      // or use `map.into_iter().unzip()` to get (keys, values).
  }
  ```

In Rust, there's no Rule of Five, and moving is always a *bitwise memcpy*.

Rust automatically dereferences through multiple layers of pointers/wrappers via
the `Deref` trait. This has no C++ equivalent.

*The Deref chain*: When you call `x.method()`, Rust’s method resolution tries
the receiver type `T`, then `&T`, then `&mut T`. If no match, it dereferences
via the `Deref` trait and repeats with the target type. This continues through
multiple layers — which is why `Box<Vec<T>>` “just works” like a `Vec<T>`. Deref
_coercion_ (for function arguments) is a separate but related mechanism that
automatically converts `&Box<String>` to `&str` by chaining `Deref` impls.

Try to write a `Deref` example myself:

```rust
use std::ops::Deref;

struct ID(u64);

impl Deref for ID {
    type Target = u64;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

fn greater_u64(a: &u64, b: &u64) -> bool {
   a > b
}

fn main() {
    let a: ID = ID(10u64);
    let b = 5u64;
    println!("{}", greater_u64(&a, &b));
}
```

References are always valid. Optional references are explicit with `Option`.

*Chapter 6: Enums and Pattern matching*

Rust enums are discriminated unions (tagged unions done right).

`match` statement must be exhaustive. The `_` can be used a wildcard for the
_all else_ case (just like using `default` in C to catch the rest of the cases).
all `match` arms (`=>`) should return a value of the same type for `match`
yielding a value.

The `matches!` macro can be used to match to specific variant of `enum`.

`match` can also perform matches using destructuring and slices:

```rust
fn main() {
    struct Foo {
        x: (u32, bool),
        y: u32
    }
    let f = Foo {x: (42, true), y: 100};
    match f {
        // Capture the value of x into a variable called tuple
        Foo{y: 100, x : tuple} => println!("Matched x: {tuple:?}"),
        _ => ()
    }
    let a = [40, 41, 42];
    match a {
        // Last element of slice must be 42. @ is used to bind the match
        [rest @ .., 42] => println!("{rest:?}"),
        // First element of the slice must be 42. @ is used to bind the match
        [42, rest @ ..] => println!("{rest:?}"),
        _ => (),
    }
}
```

*Exercise: Implement add and subtract using match and enum*

- Write a function that implements arithmetic operations on unsigned 64-bit
  numbers

- *Step 1*: Define an enum for operations:

  ```rust
  enum Operation {
      Add(u64, u64),
      Subtract(u64, u64),
  }
  ```

- *Step 2*: Define a result enum:

  ```rust
  enum CalcResult {
      Ok(u64),                    // Successful result
      Invalid(String),            // Error message for invalid operations
  }
  ```

- *Step 3*: Implement `calculate(op: Operation) -> CalcResult`

  - For Add: return Ok(sum)
  - For Subtract: return Ok(difference) if first >= second, otherwise
    Invalid(“Underflow”)

- *Hint*: Use pattern matching in your function:

  ```rust
  match op {
      Operation::Add(a, b) => { /* your code */ },
      Operation::Subtract(a, b) => { /* your code */ },
  }
  ```
*Answer*:

```rust
enum Operation {
    Add(u64, u64),
    Subtract(u64, u64),
}

enum CalcResult {
    Ok(u64),
    Invalid(String),
}

fn calculate(op: Operation) -> CalcResult {
    match op {
        Add(a, b) => CalcResult::Ok(a + b),
        Subtract(a, b) => if a >= b {
            CalcResult::Ok(a - b)
        } else {
            CalcResult::Invalid("Underflow".to_owned())
        }
    }
}
```

`impl` can define methods associated for types like `struct`, `enum`, etc.

*Exercise: Point add and transform*

- Implement the following associated methods for `Point`

  - `add()` will take another `Point` and will increment the x and y values in
    place (hint: use `&mut self`)
  - `transform()` will consume an existing `Point` (hint: use `self`) and return
    a new `Point` by squaring the x and y

*Answer*:

```rust
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    fn add(&mut self, other: &Self) {
        self.x += other.x;
        self.y += other.y;
    }

    fn transform(self) -> Self {
        Self{x: self.x * self.x, y: self.y * self.y}
    }
}
```

*Chapter 7: Ownership and Borrowing*

How does Rust make RAII *foolproof*?

- Move is *destructive* - the compiler disallow users to touch the moved-from
  variable
- No Rule of Five
- Enforces safety at compile time for memory allocation, through a combination
  of mechanics including ownership, borrowing, mutability and lifetimes
- Runtime allocations can happen both on the stack and the heap

Passing parameters:

- By value (copy): `u8`, `i32`, etc.
- By reference: `&` or `&mut`
- By moving: transfers the ownership of the value to the function

Move semantics: by default, assignment transfers ownership (no move assignment
operator, no move constructor). Borrow after move is illegal.

The `clone()` method can be used to copy the original memory with a separate heap allocation.

`Copy` trait allows to duplicate the value when moved. It doesn't guarantee the
`Copy` type to be stack-allocated, which means it can still be heap-allocated
(e.g., via `Box<T>` pointers), and a non-`Copy` type can be stack-allocated
(e.g., a custom struct `struct Point(u32,u32)`.

`Drop` trait: Rust automatically calls the `drop()` method at the end of scope.
It's like an `defer`ed `free()` call by compiler, which ensures RAII.

Users cannot call `.drop()` directly; Instead, they can use `drop(obj)`.

Unlike C++'s destructor method, `drop()` isn't called when moving objects:

- In C++, destructor still runs on the moved-from object.

  ```cpp
  struct Point {
    int x_;
    int y_;

    Point(int x, int y): x_{x}, y_{y} {}

    ~Point() {
      std::println("Point({},{}) destructed.", x_, y_);
    }

    Point(const Point&) = default;
    Point& operator=(const Point&) = default;
    Point(Point&&) = default;
    Point& operator=(Point&&) = default;
  };

  int main() {
    Point p(1, 2);
    auto p2 = p;
    p2.x_ += 1;
    return 0;
    // stdout:
    // > Point(2,2) destructed.
    // > Point(1,2) destructed.
  }
  ```

- While in Rust, desructor only calls when the resource is end of scope

  ```rust
  struct Point {
      x: i32,
      y: i32
  }

  impl Point {
      fn new(x: i32, y: i32) -> Self {
          Self{x, y}
      }
  }

  impl Drop for Point {
      fn drop(&mut self) {
          println!("Point({},{}) destructed.", self.x, self.y);
      }
  }

  fn main() {
      let p = Point::new(1, 2);
      let mut p2 = p;
      p2.x += 1;
      // stdout:
      // > Point(2,2) destructed.
  }
  ```

*Exercise: Move, Copy and Drop*

- Create your own experiments with `Point` with and without `Copy` in
  `#[derive(Debug)]` in the below make sure you understand the differences. The
  idea is to get a solid understanding of how move vs. copy works, so make sure
  to ask

- Implement a custom `Drop` for `Point` that sets x and y to 0 in `drop`. This
  is a pattern that’s useful for releasing locks and other resources for example

  ```rust
  struct Point{x: u32, y: u32}
  fn main() {
      // Create Point, assign it to a different variable, create a new scope,
      // pass point to a function, etc.
  }
  ```

The lifetime of any reference must be at least as long as the original owning
lifetime. These are implicit lifetimes and are inferred by the compiler. See
#link("https://doc.rust-lang.org/nomicon/lifetime-elision.html")[Lifetime
  Elision - The Rustonomicon].

Explicit lifetime are needed when dealing with multiple lifetimes.

Lifetime annotation starts with a tick `'` and can be any identifier, like `'a`,
`'b`, `'static`.

A common scenario: function returns a reference, but it should be clear which
input does the returned reference come from.

```rust
fn pick<'a>(pick_left: bool, left: &'a str, right: &'a str) -> &'a str {
    if pick_left { left } else { right }
}

fn always_pick_left<'a, 'b>(left: &'a str, _right: &'b str) -> &'a str {
    left
}
```

Another case: references in data structures

```rust
use std::collections::HashMap;
struct Person {id: u64, name: String}
struct LookupPersonById<'a> {
    map: HashMap<u64, &'a Person>,
}
```

*Exercise: First word with lifetimes*

Write a function `fn first_word(s: &str) -> &str` that returns the first
whitespace-delimited word from a string. Think about why this compiles without
explicit lifetime annotations (hint: elision rule \#1 and \#2).

*Answer*:

```rust
fn first_word(s: &str) -> &str {
    s.split_whitespace().next().unwrap_or(s)
}
```

*Exercise: Slice storage with lifetimes*

Create a structure that stores references to the slice of a `&str`

- Create a long `&str` and store references slices from it inside the structure
- Write a function that accepts the structure and returns the contained slice

```rust
// TODO: Create a structure to store a reference to a slice
struct SliceStore {

}
fn main() {
    let s = "This is long string";
    let s1 = &s[0..];
    let s2 = &s[1..2];
    // let slice = struct SliceStore {...};
    // let slice2 = struct SliceStore {...};
}
```

*Answer*:

```rust
struct SliceStore<'a> {
    slice: &'a str
}

// fn contained_slice<'a>(ss: SliceStore<'a>) -> &'a str
fn contained_slice(ss: SliceStore<'_>) -> &str {
    ss.slice
}

impl<'a> SliceStore<'a> {
    fn new(slice: &'a str) -> Self {
        Self { slice }
    }

    // fn get_slice(&self) -> &'a str
    fn get_slice(&self) -> &str {
        self.slice
    }
}

fn main() {
    let s = "This is long string";
    let s1 = &s[0..];
    let s2 = &s[1..2];
    let slice = SliceStore { slice: s1 };
    let slice2 = SliceStore { slice: s2 };
    let cs1 = contained_slice(slice);
    let cs2 = contained_slice(slice2);
    println!("{cs1}");
    println!("{cs2}");
}
```

The Three Elision Rules:

1. Each input reference gets its own lifetime
2. If exactly one input lifetime, assign it to all outputs
3. If one input is &self or &mut self, assign its lifetime to all outputs

*Exercise: Predict the Elision*

For each function signature below, predict whether the compiler can elide
lifetimes. If not, add the necessary annotations:

```rust
// 1. Can the compiler elide?
fn trim_prefix(s: &str) -> &str { &s[1..] }

// 2. Can the compiler elide?
fn pick(flag: bool, a: &str, b: &str) -> &str {
    if flag { a } else { b }
}

// 3. Can the compiler elide?
struct Parser { data: String }
impl Parser {
    fn next_token(&self) -> &str { &self.data[..5] }
}

// 4. Can the compiler elide?
fn split_at(s: &str, pos: usize) -> (&str, &str) {
    (&s[..pos], &s[pos..])
}
```

*Answer*:

```rust
// 1. Yes
fn trim_prefix(s: &str) -> &str { &s[1..] }

// 2. No
fn pick<'a>(flag: bool, a: &'a str, b: &'a str) -> &'a str {
    if flag { a } else { b }
}

// 3. Yes
struct Parser { data: String }
impl Parser {
    fn next_token(&self) -> &str { &self.data[..5] }
}

// 4. Yes
fn split_at(s: &str, pos: usize) -> (&str, &str) {
    (&s[..pos], &s[pos..])
}
```

`Box<T>` for heap allocation, no need to manually call `free()`, no
use-after-move. The size of the pointer is fixed, no matter how large the `<T>`
is

`Cell<T>` and `RefCell<T>` are used for interior mutability. They are usually
used in such a situation:

For the type `T`, it's desirable to keep most of it read-only while allowing to
write to a few fields.

- `Cell<T>` is used for `Copy` types, requires `T: Copy` for `.get()`
- `RefCell<T>` enforces borrow-checks at *runtime* in lieu of compile-time,
  provides `.borrow()` for immutable access and `.borrow_mut()` for mutable
  access.

The rule for borrowing is similar: one mutable borrow or (this is an exclusive
or) multiple immutable borrows.

`Rc<T>` (single-thread) allows shared immutable access. The contained type is
automatically dereferenced.

`Weak<T>` breaks reference cycles.

Consider such a situation: Two `Rc` values point to each other, neither will
ever be dropped as there's a reference cycle. `Weak<T>` (from `Rc::downgrade()`
or `Arc::downgrade()`) could solve this problem.

```rust
use std::rc::{Rc, Weak};

struct Node {
    value: i32,
    parent: Option<Weak<Node>>,  // Weak reference — doesn't prevent drop
}

fn main() {
    let parent = Rc::new(Node { value: 1, parent: None });
    let child = Rc::new(Node {
        value: 2,
        parent: Some(Rc::downgrade(&parent)),  // Weak ref to parent
    });

    // To use a Weak, try to upgrade it — returns Option<Rc<T>>
    if let Some(parent_rc) = child.parent.as_ref().unwrap().upgrade() {
        println!("Parent value: {}", parent_rc.value);
    }
    println!("Parent strong count: {}", Rc::strong_count(&parent)); // 1, not 2
}
```

Combine shared ownership with interior mutability

- `Rc<RefCell<T>>` - shared, mutable threaded data
- `Arc<Mutex<T>>` - shared, mutable multi-threaded data
- `Rc<Cell<T>>` - shared mutable Copy types

*Exercise: Shared ownership and interior mutability*

- *Part 1 (Rc)*: Create an `Employee` struct with `employee_id: u64` and `name:
  String`. Place it in an `Rc<Employee>` and clone it into two separate `Vec`s
  (`us_employees` and `global_employees`). Print from both vectors to show they
  share the same data.
- *Part 2 (Cell)*: Add an `on_vacation: Cell<bool>` field to `Employee`. Pass an
  immutable `&Employee` reference to a function and toggle `on_vacation` from
  inside that function — without making the reference mutable.
- *Part 3 (RefCell)*: Replace `name: String` with `name: RefCell<String>` and
  write a function that appends a suffix to the employee’s name through an
  `&Employee` (immutable reference).

*Starter code*:

```rust
use std::cell::{Cell, RefCell};
use std::rc::Rc;

#[derive(Debug)]
struct Employee {
    employee_id: u64,
    name: RefCell<String>,
    on_vacation: Cell<bool>,
}

fn toggle_vacation(emp: &Employee) {
    // TODO: Flip on_vacation using Cell::set()
}

fn append_title(emp: &Employee, title: &str) {
    // TODO: Borrow name mutably via RefCell and push_str the title
}

fn main() {
    // TODO: Create an employee, wrap in Rc, clone into two Vecs,
    // call toggle_vacation and append_title, print results
}
```

*Answer*:

```rust
use std::cell::{Cell, RefCell};
use std::rc::Rc;

#[derive(Debug)]
struct Employee {
    employee_id: u64,
    name: RefCell<String>,
    on_vacation: Cell<bool>,
}

fn toggle_vacation(emp: &Employee) {
    let on_vacation = emp.on_vacation.get();
    emp.on_vacation.set(!on_vacation);
}

fn append_title(emp: &Employee, title: &str) {
    emp.name.borrow_mut().push_str(title);
}

fn main() {
    let employee = Rc::new(Employee {
        employee_id: 42,
        name: RefCell::new("name".to_owned()),
        on_vacation: Cell::new(false),
    });

    let mut us_employees = vec![];
    let mut global_employees = vec![];

    us_employees.push(employee.clone());
    global_employees.push(employee.clone());
    println!("{:?}", us_employees);
    println!("{:?}", global_employees);

    toggle_vacation(&employee);
    append_title(&employee, " Dr.");

    println!("{:?}", employee);
}
```

#tufted.margin-note[
  *Checkpoint*: You can explain why `let s2 = s1` invalidates `s1`
]

*Checkpoint callback*

Because in Rust, the assignment operator defaults to moving ownership rather
than copying, and there's no way to overload the `=` operator itself. When you
write `let s2 = s1`, the ownership of the underlying resource is transferred
from `s1` to `s2`, leaving `s1` invalid and unusable afterward. However, there
is an important exception: when `s1` has a `Copy` type. Types that implement the
`Copy` trait are automatically duplicated during assignment through a bitwise
copy—similar to `memcpy` in C, which performs a shallow, mechanical duplication
of memory—so the original variable remains valid. This means for `Copy` types
like `i32` and `usize`, `let s2 = s1` leaves both variables usable, whereas for
non-`Copy` types like `String` or `Vec`, only `s2` remains valid after the
assignment.

#tufted.margin-note[
  *Suggested Time*: 1 day \
  *Checkpoint*: You can create a multi-file project that propagates errors with
  `?` \
  *Start to End*: 2026-03-30 \
]

== Day 3: Modules, error handling (Chapters 8-9)

*Chapter 8: Crates and Modules*

Each `.rs` file is its own module.

Use `pub` to make things public, or `pub(crate)` to make them public to the
current crate.

Unless explicitly listed in `main.rs` or `lib.rs`, source files aren't
automatically included in the crate.

*Exercise: Modules and functions*

#let hello-world-link = "https://play.rust-lang.org/?version=stable\&mode=debug\&edition=2021\&gist=522d86dbb8c4af71ff2ec081fb76aee7"
We’ll take a look at modifying our #link(hello-world-link)[hello world] to call
another function

- As previously mentioned, function are defined with the `fn` keyword. The `->`
  keyword declares that the function returns a value (the default is void) with
  the type `u32` (unsigned 32-bit integer)
- Functions are scoped by module, i.e., two functions with exact same name in
  two modules won’t have a name collision
  - The module scoping extends to all types (for example, a `struct foo` in
    `mod a { struct foo; }` is a distinct type (`a::foo`) from
    `mod b { struct foo; } ` (`b::foo`))

*Starter code* — complete the functions:

```rust
mod math {
    // TODO: implement pub fn add(a: u32, b: u32) -> u32
}

fn greet(name: &str) -> String {
    // TODO: return "Hello, <name>! The secret number is <math::add(21,21)>"
    todo!()
}

fn main() {
    println!("{}", greet("Rustacean"));
}
```

*Answer*:

```rust
mod math {
    pub fn add(a: u32, b: u32) -> u32 {
        a + b
    }
}

fn greet(name: &str) -> String {
    format!("Hello, {}! The secret number is {}", name, math::add(21, 21))
}

fn main() {
    println!("{}", greet("Rustacean"));
}
```

A workspace is a collection of crates that will be used to build the target
binaries.

*Exercise: Using workspaces and package dependencies*

- We’ll create a simple package and use it from our `hello world` program
- Create the workspace directory

  ```bash
  mkdir workspace
  cd workspace
  ```

- Create a file called Cargo.toml and add the following to it. This creates an
  empty workspace

  ```toml
  [workspace]
  resolver = "2"
  members = []
  ```

- Add the packages (`cargo new --lib` specifies a library instead of an
  executable)

  ```bash
  cargo new hello
  cargo new --lib hellolib
  ```

- Take a look at the generated Cargo.toml in `hello` and `hellolib`. Notice that
  both of them have been to the upper level `Cargo.toml`

- The presence of `lib.rs` in `hellolib` implies a library package (see
  #link("https://doc.rust-lang.org/cargo/reference/cargo-targets.html") for
  customization options)

- Adding a dependency on `hellolib` in `Cargo.toml` for `hello`

  ```toml
  [dependencies]
  hellolib = {path = "../hellolib"}
  ```

- Using `add()` from `hellolib`

  ```rust
  fn main() {
      println!("Hello, world! {}", hellolib::add(21, 21));
  }
  ```

The `crates.io` (#link("https://crates.io/")) help build a vibrant ecosystem,
hosting a bunch of community crates.

Use #link("https://semver.org/")[SemVer] to version crates.

Reference:
#link("https://doc.rust-lang.org/cargo/reference/specifying-dependencies.html")

*Exercise: Using the rand crate*

- Modify the `helloworld` example to print a random number
- Use `cargo add rand` to add a dependency
- Use `https://docs.rs/rand/latest/rand/` as a reference for the API

*Starter code* — add this to `main.rs` after running `cargo add rand`:

```rust
use rand::RngExt;

fn main() {
    let mut rng = rand::rng();
    // TODO: Generate and print a random u32 in 1..=100
    // TODO: Generate and print a random bool
    // TODO: Generate and print a random f64
}
```

*Answer*:

```rust
use rand::RngExt;

fn main() {
    let mut rng = rand::rng();
    let n: u32 = rng.random_range(1..=100)
    println!("random u32 in 1..=100: {n}");
    let b: bool = rng.random();
    println!("random bool: {b}");
    let f: f64 = rng.random();
    println!("random f64: {f}");
}
```

It's recommended to include `Cargo.lock` in the Git repository to ensure
reproducible builds.

By convention, write unit tests in the same source file. The test code is never
included in the actual binary thanks to the `cfg` feature, which is also useful
for creating platform specific code (`Linux` vs `Windows`).

Run test with `cargo test`. Reference:
#link("https://doc.rust-lang.org/reference/conditional-compilation.html")

Other features:

- `cargo clippy` for linting code
- `cargo format` for formatting code, which runs `rustfmt`
- `cargo doc` for generating documentation from `///` style comments.

*Build Profiles: Controlling Optimization*

`cargo build` uses `[profile.dev]` and `cargo build --release` uses
`[profile.release]`.

```toml
# Cargo.toml — build profile configuration

[profile.dev]
opt-level = 0          # No optimization (fast compile, like -O0)
debug = true           # Full debug symbols (like -g)

[profile.release]
opt-level = 3          # Maximum optimization (like -O3)
lto = "fat"            # Link-Time Optimization (like -flto)
strip = true           # Strip symbols (like the strip command)
codegen-units = 1      # Single codegen unit — slower compile, better optimization
panic = "abort"        # No unwind tables (smaller binary)
```

*Build Scripts (`build.rs`): Linking C Libraries*

Use `println!()` in the `build.rs` file at the crate root for linker
configuration:

```rust
// build.rs — runs before compiling the crate

fn main() {
    // Link a system C library (like -lbmc_ipmi in gcc)
    println!("cargo::rustc-link-lib=bmc_ipmi");

    // Where to find the library (like -L/usr/lib/bmc)
    println!("cargo::rustc-link-search=/usr/lib/bmc");

    // Re-run if the C header changes
    println!("cargo::rerun-if-changed=wrapper.h");
}
```

Use `build-dependencies.cc = "1"` to integrate with C compiler:

```toml
# Cargo.toml
[build-dependencies]
cc = "1"  # C compiler integration
```

```rust
// build.rs
fn main() {
    cc::Build::new()
        .file("src/c_helpers/ipmi_raw.c")
        .include("/usr/include/bmc")
        .compile("ipmi_raw");   // Produces libipmi_raw.a, linked automatically
    println!("cargo::rerun-if-changed=src/c_helpers/ipmi_raw.c");
}
```

After installing a cross-compilation target using `rustup target add`, it is
easy to cross compile code:

```bash
# Cross-compile
cargo build --target <target>
```

To specify the linker for a target, use a configuration similar to the following
in `.cargo/config.toml`:

```toml
[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"
```

*Feature Flags: Conditional Compilation*

Define `[features]` items and use `#[cfg(feature = "foo"]` to gate code on
features, just like in C with `#ifdef` and `-DFOO`:

```toml
# Cargo.toml
[features]
default = ["json"]         # Enabled by default
json = ["dep:serde_json"]  # Optional dependency
verbose = []               # Flag with no dependency
gpu = ["dep:cuda-sys"]     # Optional GPU support
```

```rust
// Code gated on features:
#[cfg(feature = "json")]
pub fn parse_config(data: &str) -> Result<Config, Error> {
    serde_json::from_str(data).map_err(Error::from)
}

#[cfg(feature = "verbose")]
macro_rules! verbose {
    ($($arg:tt)*) => { eprintln!("[VERBOSE] {}", format!($($arg)*)); }
}
#[cfg(not(feature = "verbose"))]
macro_rules! verbose {
    ($($arg:tt)*) => {}; // Compiles to nothing
}
```

*Integration tests* are placed in `tests/` and should only test crate's public
API. No `#[cfg(test)]` needed for integration tests, but still need `#[test]`.
There are also other testing patterns:

- `#[should_panic]` is used to test expected failures.
- `#[ignore]` is for tagging slow or hardware-dependent tests, could be included
  with `--ignored` (only run ignored tests) or `--include-ignored` (run all
  tests) flags.

With `Drop` trait, cleanups are automatic, which is really useful for tests (and
for production code).

Mocking tests are natural with traits and generic functions that work with both
real and mock.

`proptest` is great for testing properties:

```rust
// Cargo.toml: [dev-dependencies] proptest = "1"
use proptest::prelude::*;

fn parse_sensor_id(s: &str) -> Option<u32> {
    s.strip_prefix("sensor_")?.parse().ok()
}

fn format_sensor_id(id: u32) -> String {
    format!("sensor_{id}")
}

proptest! {
    #[test]
    fn roundtrip_sensor_id(id in 0u32..10000) {
        // Property: format then parse should give back the original
        let formatted = format_sensor_id(id);
        let parsed = parse_sensor_id(&formatted);
        prop_assert_eq!(parsed, Some(id));
    }

    #[test]
    fn parse_rejects_garbage(s in "[^s].*") {
        // Property: strings not starting with 's' should never parse
        let result = parse_sensor_id(&s);
        prop_assert!(result.is_none());
    }
}
```

*Snapshot testing* with `insta` crate and `cargo insta` command (should install
`cargo-insta`):

```rust
// Cargo.toml: [dev-dependencies]
// insta = { version = "1", features = ["json"] }

#[cfg(test)]
mod tests {
    use insta::assert_json_snapshot;

    #[test]
    fn der_entry_format() {
        let entry = DerEntry {
            fault_code: 67956,
            component: "GPU".to_string(),
            message: "ECC error detected".to_string(),
        };
        // First run: creates a snapshot file in tests/snapshots/
        // Subsequent runs: compares against the saved snapshot
        assert_json_snapshot!(entry);
    }
}
```

```bash
cargo insta test              # Run tests and review new/changed snapshots
cargo insta review            # Interactive review of snapshot changes
```

More on snapshot testing:

- #link(
    "https://www.sciencedirect.com/science/article/abs/pii/S0164121223001929",
  )[Snapshot testing in practice: Benefits and drawbacks - ScienceDirect]
- #link("https://insta.rs/docs/")[Overview | Insta Snapshots]

  The following quote is from #link("https://github.com/mitsuhiko/insta"), the
  GitHub source of `insta`:

  #quote[
    Snapshots tests (also sometimes called approval tests) are tests that assert
    values against a reference value (the snapshot). This is similar to how
    `assert_eq!` lets you compare a value against a reference value but unlike
    simple string assertions, snapshot tests let you test against complex values
    and come with comprehensive tools to review changes.

    Snapshot tests are particularly useful if your reference values are very
    large or change often.
  ]

*Chapter 9: Error Handling*

`Option` and `Result` are `enum`s defined in the standard library, so pattern
matching with `match` over `enum` works directly with them.

`Option` allows to separate valid values and invalid values.

#let unwrap-or-link(body) = this-book-link(
  "ch17-2-avoiding-unchecked-indexing.html#safe-value-extraction-with-unwrap_or",
  body,
)
#let map-err-link(body) = this-book-link(
  "ch17-2-avoiding-unchecked-indexing.html#functional-transforms-map-map_err-find_map",
  body,
)
*Production patterns*: See #unwrap-or-link[Safe value extraction with unwrap\_or]
and #map-err-link[Functional transforms: map, map\_err, find\_map] for
real-world examples from production Rust code.

*Rule of thumb*: Use `Option` when absence is normal (e.g., looking up a key).
Use `Result` when failure needs explanation (e.g., file I/O, parsing).

*Exercise: log() function implementation with Option*

- Implement a `log()` function that accepts an `Option<&str>` parameter. If the
  parameter is `None`, it should print a default string
- The function should return a `Result` with `()` for both success and error (in
  this case we’ll never have an error)

*Answer*:

```rust
fn log(opt: Option<&str>) -> Result<(), ()> {
    let s = match opt {
        Some(s) => s,
        None => "default string",
    };
    println!("{s}");

    // or directly:
    // println!("{}", s.unwrap_or("default string"));

    Ok(())
}
```

*Exercise: error handling*

- Implement a `log()` function with a single u32 parameter. If the parameter is
  not 42, return an error. The `Result<>` for success and error type is `()`
- Invoke `log()` function that exits with the same `Result<>` type if `log()`
  return an error. Otherwise print a message saying that log was successfully
  called

```rust
fn log(x: u32) -> ?? {

}

fn call_log(x: u32) -> ?? {
    // Call log(x), then exit immediately if it return an error
    println!("log was successfully called");
}

fn main() {
    call_log(42);
    call_log(43);
}
```

*Answer*:

```rust
fn log(x: u32) -> Result<(), ()> {
    match x {
        42 => Ok(()),
        _ => Err(()),
    }
}

fn call_log(x: u32) -> Result<(), ()> {
    log(x)?;
    println!("log was successfully called");
    Ok(())
}

fn main() {
    let _ = call_log(42);
    let _ = call_log(43);
}
```

*Error Handling Examples: Good vs Bad*

```rust
// [ERROR] BAD: Can panic unexpectedly
fn bad_config_reader() -> String {
    let config = std::env::var("CONFIG_FILE").unwrap(); // Panic if not set!
    std::fs::read_to_string(config).unwrap()           // Panic if file missing!
}

// [OK] GOOD: Handles errors gracefully
fn good_config_reader() -> Result<String, ConfigError> {
    let config_path = std::env::var("CONFIG_FILE")
        .unwrap_or_else(|_| "default.conf".to_string()); // Fallback to default

    let content = std::fs::read_to_string(config_path)
        .map_err(ConfigError::FileRead)?;                // Convert and propagate error

    Ok(content)
}

// [OK] EVEN BETTER: With proper error types
use thiserror::Error;

#[derive(Error, Debug)]
enum ConfigError {
    #[error("Failed to read config file: {0}")]
    FileRead(#[from] std::io::Error),

    #[error("Invalid configuration: {message}")]
    Invalid { message: String },
}

fn read_config(path: &str) -> Result<String, ConfigError> {
    let content = std::fs::read_to_string(path)?;  // io::Error → ConfigError::FileRead
    if content.is_empty() {
        return Err(ConfigError::Invalid {
            message: "config file is empty".to_string(),
        });
    }
    Ok(content)
}
```

*Self-study checkpoint*: Before continuing, make sure you can answer:

- Why does `?` on the `read_to_string` call work? (Because `#[from]` generates
  `impl From<io::Error> for ConfigError`)
- What happens if you add a third variant `MissingKey(String)` — what code
  changes? (Just add the variant; existing code still compiles)

*Crate-Level Error Types and Result Aliases*

In real-world Rust projects, every crate (or significant module) defines its own
`Error` enum and a `Result` type alias. This is the idiomatic pattern
— analogous to how in C++ you’d define a per-library exception hierarchy and
using `Result = std::expected<T, Error>`.

```rust
// src/error.rs  (or at the top of lib.rs)
use thiserror::Error;

/// Every error this crate can produce.
#[derive(Error, Debug)]
pub enum Error {
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),          // auto-converts via From

    #[error("JSON parse error: {0}")]
    Json(#[from] serde_json::Error),     // auto-converts via From

    #[error("Invalid sensor id: {0}")]
    InvalidSensor(u32),                  // domain-specific variant

    #[error("Timeout after {ms} ms")]
    Timeout { ms: u64 },
}

/// Crate-wide Result alias — saves typing throughout the crate.
pub type Result<T> = core::result::Result<T, Error>;
```

*Composing module-level errors*

Larger crates split errors by module, then compose them at the crate root:

```rust
// src/config/error.rs
#[derive(thiserror::Error, Debug)]
pub enum ConfigError {
    #[error("Missing key: {0}")]
    MissingKey(String),
    #[error("Invalid value for '{key}': {reason}")]
    InvalidValue { key: String, reason: String },
}

// src/error.rs  (crate-level)
#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error(transparent)]               // delegates Display to inner error
    Config(#[from] crate::config::ConfigError),

    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
}
pub type Result<T> = core::result::Result<T, Error>;
```

Callers can still match on specific config errors:

```rust
match result {
    Err(Error::Config(ConfigError::MissingKey(k))) => eprintln!("Add '{k}' to config"),
    Err(e) => eprintln!("Other error: {e}"),
    Ok(v) => use_value(v),
}
```

#tufted.margin-note[*Checkpoint*: You can create a multi-file project that propagates errors with `?`]

*Checkpoint callback*

```bash
cargo new --bin ppg
cd ppg
cargo add thiserror
touch src/{temperature,error,read}.rs
```

```rust
// src/main.rs
mod error;
mod read;
mod temperature;

fn main() {
    println!("Please enter a temperature (e.g., 100C, 212F):");
    match read::read_temperature_from_stdin() {
        Ok(temp) => {
            let celsius = temp.to_celsius();
            let fahrenheit = temp.to_fahrenheit();
            println!(
                "Input: {:?}\nCelsius: {:.2} °C\nFahrenheit: {:.2} °F",
                temp,
                f64::from(celsius),
                f64::from(fahrenheit)
            );
        }
        Err(e) => eprintln!("Error: {}", e),
    }
}

// src/temperature.rs
#[derive(Debug, Clone, Copy)]
pub enum Temperature {
    Celsius(f64),
    Fahrenheit(f64),
}

impl Temperature {
    pub fn to_celsius(&self) -> Self {
        match self {
            Temperature::Celsius(c) => Self::Celsius(*c),
            Temperature::Fahrenheit(f) => Self::Celsius((f - 32.0) * 5.0 / 9.0),
        }
    }

    pub fn to_fahrenheit(&self) -> Self {
        match self {
            Temperature::Celsius(c) => Self::Fahrenheit(c * 9.0 / 5.0 + 32.0),
            Temperature::Fahrenheit(f) => Self::Fahrenheit(*f),
        }
    }
}

impl From<Temperature> for f64 {
    fn from(temp: Temperature) -> Self {
        match temp {
            Temperature::Celsius(c) => c,
            Temperature::Fahrenheit(f) => f,
        }
    }
}


// src/error.rs
#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("I/O error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Input format error: expected a number followed by 'C' or 'F'")]
    InputFormat,
    #[error("Parse error: {0}")]
    Parse(#[from] std::num::ParseFloatError),
}

pub type Result<T> = core::result::Result<T, Error>;

// src/read.rs
use super::error::{Error, Result};
use super::temperature::Temperature;
use std::io::stdin;

pub fn read_temperature_from_stdin() -> Result<Temperature> {
    let mut input = String::new();
    stdin().read_line(&mut input)?;
    let (value, unit) = input
        .trim()
        .split_at_checked(input.trim().len() - 1)
        .ok_or(Error::InputFormat)?;
    match unit {
        "C" => Ok(Temperature::Celsius(value.parse()?)),
        "F" => Ok(Temperature::Fahrenheit(value.parse()?)),
        _ => Err(Error::InputFormat),
    }
}
```

#tufted.margin-note[
  *Suggested Time*: 1-2 days \
  *Checkpoint*: You can write a generic function with trait bounds \
  *Start to End*: 2026-03-31 to 2026-04-01
]

== Day 4-5: Traits, generics, closures (Chapter 10-12)

*Chapter 10: Traits*

Rust use `Trait`s to implement interfaces, abstract base classes and operator
overloading.

If traditional C++ inheritance signifies a _is-a_ relation, Rust's traits imply
a _can-do_ behaviour.

In Rust, operators map to `std::ops` traits, e.g. `std::ops:Add` for `+`,
`std::ops::Index` for `[]`.

- Try to enrich my previous `Deref` example code with some other traits:

  ```rust
  use std::fmt::Debug;
  use std::ops::{Deref, Add};

  #[derive(Debug)]
  struct ID(u64);

  impl Deref for ID {
      type Target = u64;

      fn deref(&self) -> &Self::Target {
          &self.0
      }
  }

  impl Add<u64> for ID {
      type Output = ID;

      fn add(self, rhs: u64) -> Self::Output {
          Self(self.0 + rhs)
      }
  }

  fn main() {
      let a: ID = ID(10u64);
      let b = 5u64;
      println!("{}", *a > b);
      let a = a + b;
      let b = b + *a;
      println!("{:?}", a);
      println!("{}", b);
  }
  ```

When `impl`ing a trait for a type, either the trait or the type must belong to
the current crate.

There could be default implementations and interface inheritance in Rust's
traits.

- My example (not good but work)

  ```rust
  trait Name {
      fn name(&self) -> &str;
  }

  trait Greeting {
      fn greeting(&self) -> &str;
  }

  trait NiceToMeetYou : Name + Greeting {
      fn nice_to_meet_you(&self) -> String {
          let greeting = self.greeting();
          let name = self.name();
          format!("{greeting}! My name is {name}.")
      }
  }

  struct Person {
      name: String,
      greeting: String,
  }

  impl Name for Person {
      fn name(&self) -> &str {
          &self.name
      }
  }

  impl Greeting for Person {
      fn greeting(&self) -> &str {
          &self.greeting
      }
  }

  impl NiceToMeetYou for Person {}

  fn main() {
      let alice = Person {
          name: "Alice".to_string(),
          greeting: "Hi".to_string(),
      };
      println!("{}", alice.nice_to_meet_you());
  }
  ```

*Exercise: Logger trait implementation*

- Implement a `Log trait` with a single method called `log()` that accepts a u64
  - Implement two different loggers `SimpleLogger` and `ComplexLogger` that
    implement the `Log trait`. One should output "Simple logger" with the `u64`
    and the other should output "Complex logger" with the `u64`

*Answer*:

```rust
trait Log {
    fn log(&self, n: u64);
}

struct SimpleLogger;

struct ComplexLogger;

impl Log for SimpleLogger {
    fn log(&self, n: u64) {
        println!("Simple logger: {n}");
    }
}

impl Log for ComplexLogger {
    fn log(&self, n: u64) {
        println!("Complex logger: {n}");
    }
}

fn main() {
    let s = SimpleLogger{};
    let c = ComplexLogger{};
    s.log(42);
    c.log(42);
}
```

Trait impl (`impl Trait`) can be used with traits

- to accept any type that implements a trait
- in a return value.

Dynamic traits (`dyn Trait`) can be used to invoke the trait functionality
without knowing the underlying type. This is known as `type erasure`.

*Choosing Between `impl Trait`, `dyn Trait`, and Enums*:

```rust
trait Shape {
    fn area(&self) -> f64;
}
struct Circle { radius: f64 }
struct Rect { w: f64, h: f64 }
impl Shape for Circle { fn area(&self) -> f64 { std::f64::consts::PI * self.radius * self.radius } }
impl Shape for Rect   { fn area(&self) -> f64 { self.w * self.h } }

// Static dispatch — compiler generates separate code for each type
fn print_area(s: &impl Shape) { println!("{}", s.area()); }

// Dynamic dispatch — one function, works with any Shape behind a pointer
fn print_area_dyn(s: &dyn Shape) { println!("{}", s.area()); }

// Enum — closed set, no trait needed
enum ShapeEnum { Circle(f64), Rect(f64, f64) }
impl ShapeEnum {
    fn area(&self) -> f64 {
        match self {
            ShapeEnum::Circle(r) => std::f64::consts::PI * r * r,
            ShapeEnum::Rect(w, h) => w * h,
        }
    }
}
```

*Rule of thumb*: Start with `impl Trait` (static dispatch). Reach for `dyn
Trait` only when you need heterogeneous collections or can’t know the concrete
type at compile time. Use `enum` when you own all the variants.

Generics are used to reuse the same algorithm or data structure across data
types.

*Exercise: Generies*

- Modify the `Point` type to use two different types (`T` and `U`) for x and y

  ```rust
  #[derive(Debug)] // We will discuss this later
  struct Point<T> {
      x : T,
      y : T,
  }
  impl<T> Point<T> {
      fn new(x: T, y: T) -> Self {
          Point {x, y}
      }
      fn set_x(&mut self, x: T) {
           self.x = x;
      }
      fn set_y(&mut self, y: T) {
           self.y = y;
      }
  }
  impl Point<f32> {
      fn is_secret(&self) -> bool {
          self.x == 42.0
      }
  }
  fn main() {
      let mut p = Point::new(2, 4); // i32
      let q = Point::new(2.0, 4.0); // f32
      p.set_x(42);
      p.set_y(43);
      println!("{p:?} {q:?} {}", q.is_secret());
  }
  ```

*Answer*:

```rust
#[derive(Debug)]
struct Point<T, U> {
    x : T,
    y : U,
}
impl<T, U> Point<T, U> {
    fn new(x: T, y: U) -> Self {
        Point {x, y}
    }
}
fn main() {
    let p = Point::new(true, 42);
    let q = Point::new(3.25, "hello");
    println!("{p:?} {q:?}");
}
```

Traits can be used to add constraint to generic types. Use `+` to combine trait
constraints.

*Exercise: Trait constraints and generics*

- Implement a `struct` with a generic member `cipher` that implements
  `CipherText`

  ```rust
  trait CipherText {
      fn encrypt(&self);
  }
  // TO DO
  //struct Cipher<>
  ```

- Next, implement a method called `encrypt` on the `struct` `impl` that invokes
  `encrypt` on `cipher`

  ```rust
  // TO DO
  impl for Cipher<> {}
  ```

- Next, implement `CipherText` on two structs called `CipherOne` and `CipherTwo`
  (just `println()` is fine). Create `CipherOne` and `CipherTwo`, and use
  `Cipher` to invoke them

*Answer*:

```rust
trait CipherText {
    fn encrypt(&self);
}

struct Cipher<T: CipherText> {
    cipher: T,
}

impl<T: CipherText> Cipher<T> {
    fn encrypt(&self) {
        self.cipher.encrypt();
    }
}

struct CipherOne;
struct CipherTwo;

impl CipherText for CipherOne {
    fn encrypt(&self) {
        println!("CipherOne");
    }
}

impl CipherText for CipherTwo {
    fn encrypt(&self) {
        println!("CipherTwo");
    }
}

fn main() {
    let c1 = Cipher { cipher: CipherOne };
    let c2 = Cipher { cipher: CipherTwo };
    c1.encrypt();
    c2.encrypt();
}
```

Generics can be used to enforce state machine transitions *at compile time*:

Consider a `Drone` with say two states: `Idle` and `Flying`. In the `Idle` state,
the only permitted method is `takeoff()`. In the `Flying` state, we permit
`land()`.

One approach is to model the state machine with `enum`, like the following:

```rust
#[derive(Debug)]
enum DroneState {
    Idle,
    Flying
}

#[derive(Debug)]
struct Drone {
    x: u64,
    y: u64,
    z: u64,
    state: DroneState,
}

impl Drone {
    fn new() -> Self {
        Self {
            x: 0,
            y: 0,
            z: 0,
            state: DroneState::Idle,
        }
    }

    fn takeoff(&mut self) {
        match self.state {
            DroneState::Idle => {
                println!("Taking off");
                self.z += 1;
                self.state = DroneState::Flying;
            }
            _ => {
                panic!("This is not permitted as the state is {:?}", self.state);
            }
        }
    }

    fn land(&mut self) {
        match self.state {
            DroneState::Flying => {
                println!("Landing");
                self.z -= 1;
                self.state = DroneState::Idle;
            }
            _ => {
                panic!("This is not permitted as the state is {:?}", self.state);
            }
        }
    }
}

fn main() {
    let mut drone = Drone::new();
    println!("{drone:?}");
    drone.takeoff();
    println!("{drone:?}");
    drone.land();
    println!("{drone:?}");
}
```

This requires many runtime checks.

For a zero cost abstraction solution, let's use generics and `PhantomData<T>`,
a zero-sized marker data type. This allows the compiler to enforce the state
machine at compile time. A possible implementation is like the following:

```rust
use std::marker::PhantomData;

#[derive(Debug)]
struct Drone<T> {
    x: u64,
    y: u64,
    z: u64,
    state: PhantomData<T>,
}

impl<T> Drone<T> {
    fn new() -> Self {
        Self {
            x: 0,
            y: 0,
            z: 0,
            state: PhantomData,
        }
    }
}

#[derive(Debug)]
struct Idle;

#[derive(Debug)]
struct Flying;

impl Drone<Idle> {
    fn takeoff(self) -> Drone<Flying> {
        println!("Taking off");
        Drone {
            x: self.x,
            y: self.y,
            z: self.z + 1,
            state: PhantomData,
        }
    }
}

impl Drone<Flying> {
    fn land(self) -> Drone<Idle> {
        println!("Landing");
        Drone {
            x: self.x,
            y: self.y,
            z: self.z - 1,
            state: PhantomData,
        }
    }
}

fn main() {
    let drone = Drone::new();
    println!("{drone:?}");
    let drone = drone.takeoff();
    println!("{drone:?}");
    let drone = drone.land();
    println!("{drone:?}");
}
```

*Chapter 11: From and Into Traits*

`From` and `Into` are complementary traits to simplify type conversion.

Once `impl From<T> for U`, get `impl Into<U> for T` for free. For example, the
`String::from()` can convert from `&str` to `String`, and the compiler
automatically derive a `&str.into` for getting a `String` from `&str`.

*Exercise: From and Into*

- Implement a `From` trait for `Point` to convert into a type called
  `TransposePoint`. `TransposePoint` swaps the `x` and `y` elements of `Point`.

*Answer*:

```rust
struct Point {
    x: u32,
    y: u32,
}

struct TransposePoint {
    x: u32,
    y: u32,
}

impl From<Point> for TransposePoint {
    fn from(value: Point) -> Self {
        Self {
            x: value.y,
            y: value.x,
        }
    }
}

fn main() {
    let p = Point { x: 10, y: 20 };
    let tp = TransposePoint::from(p);
    println!("TransposePoint: x={}, y={}", tp.x, tp.y);

    let p = Point { x: 30, y: 40 };
    let tp: TransposePoint = p.into();
    println!("TransposePoint: x={}, y={}", tp.x, tp.y);
}
```

`Default` trait is used to implement default values for a type: use
`#[derive(Default)]` over `T` or provide a custom `impl Default for T`.

*Chapter 12: Closures*

Closures are anonymous functions, just like lambdas in C++. They can capture
their environment. The compiler automatically selects one of the three capture
traits for closures: `Fn`, `FnMut` and `FnOnce`.

*Exercise: Closures and capturing*

- Create a closure that captures a `String` from the enclosing scope and appends
  to it ~(hint: use `move`)~
- Create a vector of closures: `Vec<Box<dyn Fn(i32) -> i32>>` containing
  closures that add 1, multiply by 2, and square the input. Iterate over the
  vector and apply each closure to the number 5

```rust
fn main() {
    let mut s = String::from("hello, ");
    let mut append = |suffix: &str| s.push_str(suffix);
    append("world");
    append("!");
    println!("{}", s);

    let v: Vec<Box<dyn Fn(i32) -> i32>> = vec![
        Box::new(|n| n + 1),
        Box::new(|n| n * 2),
        Box::new(|n| n * n),
    ];
    for closure in v {
        println!("{}", closure(5));
    }
}
```

Closures are mostly used with iterators.

Most of the iterators are _lazy_, i.e. they don't do anything until they are
evaluated.

*Exercise: Rust iterators*

- Create an integer array composed of odd and even elements. Iterate over the
  array and split it into two different vectors with even and odd elements in
  each
- Can this be done in a single pass (hint: use `partition()`)?

```rust
fn main() {
    let v = vec![1, 2, 3, 4];
    let odd: Vec<_> = v
        .iter()
        .filter(|x| *x % 2 == 1)
        .collect();
    let even: Vec<_> = v
        .iter()
        .filter(|x| *x % 2 == 0)
        .collect();
    println!("{v:?} {odd:?} {even:?}");

    // in a single pass, could also use `.into_iter()`
    let (odd, even): (Vec<_>, Vec<_>) = v
        .iter()
        .cloned()
        .partition(|x| *x % 2 == 1);
    println!("{v:?} {odd:?} {even:?}");
}
```

*Exercise: Iterator chains*

Given sensor data as `Vec<(String, f64)>` (name, temperature), write a *single
iterator chain* that:

1. Filters sensors with temp > 80.0
2. Sorts them by temperature (descending)
3. Formats each as `"{name}: {temp}°C [ALARM]"`
4. Collects into `Vec<String>`

Hint: you’ll need `.collect()` before `.sort_by()`, since sorting requires
a `Vec`.

*Answer*:

```rust
fn main() {
    let data: Vec<(String, f64)> = vec![
        ("a".into(), 70.0),
        ("b".into(), 82.0),
        ("c".into(), 80.0),
        ("d".into(), 95.0),
        ("e".into(), 50.0),
        ("f".into(), 107.0),
        ("g".into(), 10.0),
        ("h".into(), 84.0),
    ];
    let mut data: Vec<_> = data
        .into_iter()
        .filter(|(_, temp)| *temp > 80.0)
        .collect::<Vec<_>>();
    // EXPECT: data should contain no NAN
    data.sort_by(|(_, a), (_, b)| b.partial_cmp(a).unwrap());
    let data: Vec<_> = data
        .into_iter()
        .map(|(name, temp)| format!("{name}: {temp}°C [ALARM]"))
        .collect();
    println!("{data:?}");
}
```

The Iterator trait is used to implement iteration over user defined types.

*Reference*: #link("https://doc.rust-lang.org/std/iter/trait.IntoIterator.html")

- In the example, we’ll implement an iterator for the Fibonacci sequence, which
  starts with 1, 1, 2, … and the successor is the sum of the previous two
  numbers
- The associated type in the Iterator (`type Item = u32;`) defines the output
  type from our iterator (`u32`)
- The `next()` method simply contains the logic for implementing our iterator.
  In this case, all state information is available in the Fibonacci structure
  - We could have implemented another trait called IntoIterator to implement the
  `into_iter()` method for more specialized iterators

```rust
struct Fibonacci {
    current: u32,
    next: u32,
}

impl Fibonacci {
    fn new() -> Self {
        Self { current: 0, next: 1 }
    }
}

impl Iterator for Fibonacci {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        let next = self.current.checked_add(self.next)?;
        self.current = self.next;
        self.next = next;
        Some(self.current)
    }
}

fn main() {
    let fib = Fibonacci::new();
    for n in fib.take(10) {
        println!("{}", n);
    }
}
```

*Exercise: Sensor Data Pipeline*

Given raw sensor readings (one per line, format `"sensor_name:value:unit"`),
write an iterator pipeline that:

1. Parses each line into `(name, f64, unit)`
2. Filters out readings below a threshold
3. Groups by sensor name using `fold` into a `HashMap`
4. Prints the average reading per sensor

```rust
// Starter code
fn main() {
    let raw_data = vec![
        "gpu_temp:72.5:C",
        "cpu_temp:65.0:C",
        "gpu_temp:74.2:C",
        "fan_rpm:1200.0:RPM",
        "cpu_temp:63.8:C",
        "gpu_temp:80.1:C",
        "fan_rpm:1150.0:RPM",
    ];
    let threshold = 70.0;
    // TODO: Parse, filter values >= threshold, group by name, compute averages
}
```

*Answer*:

```rust
fn main() {
    let raw_data = vec![
        "gpu_temp:72.5:C",
        "cpu_temp:65.0:C",
        "gpu_temp:74.2:C",
        "fan_rpm:1200.0:RPM",
        "cpu_temp:63.8:C",
        "gpu_temp:80.1:C",
        "fan_rpm:1150.0:RPM",
    ];
    let threshold = 70.0;

    use std::collections::HashMap;
    let data = raw_data
        .iter()
        .filter_map(|line| {
            let parts: Vec<_> = line.splitn(3, ':').collect();
            if parts.len() == 3 {
                let f: f64 = parts[1].parse().ok()?;
                Some((parts[0], f, parts[2]))
            } else {
                None
            }
        })
        .filter(|(_, f, _)| *f >= threshold)
        .fold(HashMap::<&str, Vec<(f64, &str)>>::new(), |mut acc, (name, f, unit)| {
            acc.entry(name).or_default().push((f, unit));
            acc
        });
    for (k, v) in &data {
        let (avg, unit) = v.iter().fold((0f64, ""), |acc, x| (acc.0 + x.0, x.1));
        let avg = avg / v.len() as f64;
        println!("{k}: {avg} {unit}");
    }
}
```

#tufted.margin-note[
  *Checkpoint*: You can write a generic function with trait bounds
]

*Checkpoint callback*

```rust
use std::fmt::Debug;

fn debugln_twice<T: Debug>(data: T) {
    println!("{:?}", data);
    println!("{:?}", data);
}
```

#tufted.margin-note[
  *Suggested Time*: 1 day \
  *Checkpoint*: You can write a thread-safe counter with `Arc<Mutex<T>>` \
  *Start to End*: 2026-04-03
]

== Day 6: Concurrency, unsafe/FFI (Chapters 13-14)

*Chapter 13: Concurrency*

Rust prevents data races at compile time through `Send` and `Sync` marker
traits. For example, in C++, sharing a `std::vector` across threads without
a mutex is a UB but compiles fine; While in Rust, it won't compile.

```cpp
// This is good: lock before accessing.
void good() {
  std::vector<int> v;
  std::mutex m;

  auto t1 = std::thread([&](){
    std::lock_guard<std::mutex> _lock;
    v.emplace_back(1);
  });
  auto t2 = std::thread([&](){
    std::lock_guard<std::mutex> _lock;
    v.emplace_back(2);
  });

  t1.join();
  t2.join();

  for (int x : v) {
    std::cout << x << '\n';
  }
}

// This still compiles, but has UB.
void bad() {
  std::vector<int> v;

  auto t1 = std::thread([&](){
    v.emplace_back(1);
  });
  auto t2 = std::thread([&](){
    v.emplace_back(2);
  });

  t1.join();
  t2.join();

  for (int x : v) {
    std::cout << x << '\n';
  }
}
```

```rust
fn good() {
    let v = Arc::new(Mutex::new(vec![]));

    let v1 = Arc::clone(&v);
    let t1 = thread::spawn(move || {
        let guard = v1.lock().unwrap();
        guard.push(1);
    });

    let v2 = Arc::clone(&v);
    let t2 = thread::spawn(move || {
        let guard = v2.lock().unwrap();
        guard.push(2);
    });

    t1.join().unwrap();
    t2.join().unwrap();

    println!("{:?}", v.lock().unwrap());
}

// fn wont_compile() {
//     let mut v: Vec<i32> = vec![];
//     let t1 = thread::spawn(|| {
//         v.push(1);
//     });
//     let t2 = thread::spawn(|| {
//         v.push(2);
//     });
//     t1.join().unwrap();
//     t2.join().unwrap();
//     println!("{:?}", v);
// }

// fn wont_compile2() {
//     let v = Arc::new(vec![]);
//     let v1 = Arc::clone(&v);
//     let t1 = thread::spawn(move || {
//         v1.push(1);
//     });
//     let v2 = Arc::clone(&v);
//     let t2 = thread::spawn(move || {
//         v2.push(2);
//     });
//     t1.join().unwrap();
//     t2.join().unwrap();
//     println!("{:?}", v);
// }
```

`thread::scope()` can be used when it's necessary to borrow from the environment,
as `thread::scope` waits until the internal thread returns (or in another way to
think about it, `thread::scope` guarantees all spawned threads are joined before
the scope function returns).

Use `move` to transfer ownership to the thread.

- Read only case: `Arc<T>` can be used to share _read-only_ references.
- Read and write case:
  - `Arc<Mutex<T>>` is used when the frequency of read and write is similar or
    the critical sections are short. (C++: `std::mutex`)
  - `Arc<RwLock<T>>` is used when read is far more frequent than write. Use
    `.read()` and `.write()`. (C++: `std::shared_mutex`)

If a thread panics while holding a `Mutex` or `RwLock`, the lock becomes
poisoned. This concept has no C++ equivalent: in C++, the lock just keeps held
by the panicking thread. Use `.into_inner()` to recover.

`std::sync::atomic` types are used to avoid the overhead of a `Mutex`. They are
equivalent to C++ `std::atomic<T>` with same memory ordering model from `std::
sync::atomic::Ordering` (`Relaxed`, `Acquire`, `Release`, `SeqCst`) .

*But what do theses memory orderings mean? I have zero knowledge.* See
#link("https://doc.rust-lang.org/nomicon/atomics.html")[Atomics - The
  Rustonomicon].

Use condition variable `Condvar` (equivalent to C++ `std::condition_variable`)
to let a thread sleep until another thread signals that a condition has changed.

- Always paired with a `Mutex`: lock, check, wait if not ready, and act when
  ready.
- Always re-check the condition in a loop, or use `wait_while`/`wait_until` to
  handle spurious wakeups.

```rust
use std::sync::{Arc, Condvar, Mutex};
use std::thread;

fn main() {
    let pair = Arc::new((Mutex::new(false), Condvar::new()));

    // Spawn a worker that waits for a signal
    let pair2 = Arc::clone(&pair);
    let worker = thread::spawn(move || {
        let (lock, cvar) = &*pair2;
        let mut ready = lock.lock().unwrap();
        // wait: sleeps until signaled (always re-check in a loop for spurious wakeups)
        while !*ready {
            ready = cvar.wait(ready).unwrap();
        }
        println!("Worker: condition met, proceeding!");
    });

    // Main thread does some work, then signals the worker
    thread::sleep(std::time::Duration::from_millis(100));
    {
        let (lock, cvar) = &*pair;
        let mut ready = lock.lock().unwrap();
        *ready = true;
        cvar.notify_one();  // Wake one waiting thread (notify_all() wakes all)
    }

    worker.join().unwrap();
}
```

Channels are used to exchange messages between `Sender` and `Receiver`, with
a _multi-producer, single consumer_ paradigm `mpsc`. Both `send()` and `recv()`
can block the thread.

`Send` and `Sync` marker traits are used to enforce thread safety at compile
time:

- `Send`: it can be safely given (ownership transferred) to another threa.
- `Sync`: it can be safely shared (read-only reference `&T`) with other threads.

Notes:

- `Rc<T>` is not `Send` nor `Sync`; Use `Arc<T>`.
- `Cell<T>` and `RefCell` are not `Sync`; Use `Mutex<T>` or `RwLock<T>`.
- Raw pointers `*const T` and `*mut T` are not `Send` nor `Sync`.

#quote[
  *Intuition* _(Jon Gjengset)_: Think of values as toys. *`Send`* = you can
  *give your toy away* to another child (thread) — transferring ownership is
  safe. *`Sync`* = you can *let others play with your toy at the same time* —
  sharing a reference is safe. An `Rc<T>` has a fragile (non-atomic) reference
  counter; handing it off or sharing it would corrupt the count, so it is
  neither `Send` nor `Sync`.
]

*Exercise: Multi-threaded word count*

- Given a `Vec<String>` of text lines, spawn one thread per line to count the
  words in that line
- Use `Arc<Mutex<HashMap<String, usize>>>` to collect results
- Print the total word count across all lines
- *Bonus*: Try implementing this with channels (`mpsc`) instead of shared
  state

*Answer*:

```rust
use std::collections::HashMap;
use std::thread;
use std::sync::{Arc, Mutex, mpsc};

fn main() {
    let data: Vec<String> = vec![
        "Hello world".into(),
        "Hi world".into(),
    ];

    reference_answer(&data);
    use_threads(&data);
    use_mpsc_channel(&data);
}

fn reference_answer(data: &Vec<String>) {
    let mut results = HashMap::new();
    for line in data {
        for word in line.split_whitespace() {
            *results.entry(word.to_string()).or_insert(0usize) += 1;
        }
    }
    println!("-- reference_answer --");
    println!("+ Total count: {}", results.values().sum::<usize>());
    for (word, count) in results.iter() {
        println!("| {word}: {count}");
    }
    println!("----------------------");
}

fn use_threads(data: &Vec<String>) {
    let results = Arc::new(
        Mutex::new(HashMap::<String, usize>::new())
    );

    let mut handles = vec![];
    for line in data {
        let line = line.clone();
        let r = Arc::clone(&results);
        handles.push(thread::spawn(move || {
            let mut guard = r.lock().unwrap();
            for word in line.split_whitespace() {
                *guard.entry(word.to_string()).or_insert(0usize) += 1;
            }
        }));
    }

    handles.into_iter().for_each(|h| h.join().unwrap());

    let guard = results.lock().unwrap();
    println!("-- use_threads --");
    println!("+ Total count: {}", guard.values().sum::<usize>());
    for (word, count) in guard.iter() {
        println!("| {word}: {count}");
    }
    println!("-----------------");
}

fn use_mpsc_channel(data: &Vec<String>) {
    let (sender, receiver) = mpsc::channel();

    for line in data {
        let line = line.clone();
        let s = sender.clone();
        thread::spawn(move || {
                for word in line.split_whitespace() {
                    s.send(word.to_string()).unwrap();
                }
        });
    }
    drop(sender);

    let mut results = HashMap::new();
    for word in receiver.iter() {
        *results.entry(word).or_insert(0usize) += 1;
    }
    println!("-- use_mpsc_channel --");
    println!("+ Total count: {}", results.values().sum::<usize>());
    for (word, count) in results.iter() {
        println!("| {word}: {count}");
    }
    println!("----------------------");
}
```

*Chapter 14: Unsafe Rust and FFI*

`unsafe` allows to do what are normally disallowed by the Rust compiler, e.g.
dereferencing raw pointers, accessing _mutable_ static variables (see
#link("https://doc.rust-lang.org/book/ch19-01-unsafe-rust.html")). Programmers
should take responsibility for what the compiler normally guarantees, e.g. no
dangling pointers, no invalid references, keep `unsafe` scope as small as
possible, and write a `SAFETY` comment explaining why/how the `unsafe` scope is
safe with which assumptions. Callers of `unsafe` code should also have comments
on safety.

Always test `unsafe` code for verifying correctness. If still in doubt, consult
experts for advice.

FFI stands for _Foreign Function Interface_. It's the mechanism Rust uses to
call functions written in other languages and vice versa.

Use `#[no_mangle]` to ensure that the name of FFI methods are not mangled by the
compiler; use also `extern "C"` for C.

```rust
#[no_mangle]
pub extern "C" fn add(left: u64, right: u64) -> u64 {
    left + right
}
```

`cbindgen` is a great tool used to generate header files for exported Rust
functions. Functions and structures can be exported using `#[no_mangle]` and
`#[repr(C)]`. Note that if we want only a opaque pointer `*mut T` in C,
`#[repr(C)]` is not needed.

See #link("https://doc.rust-lang.org/nomicon/intro.html")[Introduction - The
  Rustonomicon] for more.

Use Miri for verifying pure Rust `unsafe` code, Valgrind for FFI integration,
and `cargo-careful` for extra runtime checks.

```rust
// miri
rustup component add miri
cargo miri test

// valgrind
cargo install cargo-valgrind // integration, not Valgrind itself
cargo valgrind test

// cargo-careful
cargo install cargo-careful
cargo careful test
```

`cbindgen` is (C) FFI to Rust, and `bindgen` is the other direction.

*Exercise: Writing a safe FFI wrapper*

- Write a safe Rust wrapper around an `unsafe` FFI-style function. The exercise
  simulates calling a C function that writes a formatted string into
  a caller-provided buffer.
- *Step 1*: Implement the unsafe function `unsafe_greet` that writes a greeting
  into a raw `*mut u8` buffer
- *Step 2*: Write a safe wrapper `safe_greet` that allocates a `Vec<u8>`, calls
  the unsafe function, and returns a `String`
- *Step 3*: Add proper `// Safety:` comments to every unsafe block

*Starter code*:

```rust
use std::fmt::Write as _;

/// Simulates a C function: writes "Hello, <name>!" into buffer.
/// Returns the number of bytes written (excluding null terminator).
/// # Safety
/// - `buf` must point to at least `buf_len` writable bytes
/// - `name` must be a valid pointer to a null-terminated C string
unsafe fn unsafe_greet(buf: *mut u8, buf_len: usize, name: *const u8) -> isize {
    // TODO: Build greeting, copy bytes into buf, return length
    // Hint: use std::ffi::CStr::from_ptr or iterate bytes manually
    todo!()
}

/// Safe wrapper — no unsafe in the public API
fn safe_greet(name: &str) -> Result<String, String> {
    // TODO: Allocate a Vec<u8> buffer, create a null-terminated name,
    // call unsafe_greet inside an unsafe block with Safety comment,
    // convert the result back to a String
    todo!()
}

fn main() {
    match safe_greet("Rustacean") {
        Ok(msg) => println!("{msg}"),
        Err(e) => eprintln!("Error: {e}"),
    }
    // Expected output: Hello, Rustacean!
}
```

*Answer*:

```rust
/// Simulates a C function: writes "Hello, <name>!" into buffer.
/// Returns the number of bytes written (excluding null terminator).
/// # Safety
/// - `buf` must point to at least `buf_len` writable bytes
/// - `name` must be a valid pointer to a null-terminated C string
unsafe fn unsafe_greet(buf: *mut u8, buf_len: usize, name: *const u8) -> isize {
    use std::ffi::CStr;
    use std::ptr;

    // SAFETY: Caller guarantees that `name` must be a valid pointer to
    // a null-terminated C string.
    let name = unsafe { CStr::from_ptr(name as *const i8) };
    let name = match name.to_str() {
        Ok(s) => s,
        Err(_) => return -1,
    };

    let greeting = format!("Hello, {name}!");
    let greeting_len = greeting.len();
    if greeting_len > buf_len {
        return -1;
    }

    // SAFETY: Caller guarantees that `buf` points to at least `buf_len`
    // writable bytes.
    unsafe {
        ptr::copy_nonoverlapping(greeting.as_ptr(), buf, greeting_len);
    }
    greeting_len as isize
}

/// Safe wrapper — no unsafe in the public API
fn safe_greet(name: &str) -> Result<String, String> {
    let mut buf = [0u8; 256];

    let name: Vec<u8> = name.bytes().chain(std::iter::once(0)).collect();

    // SAFETY: buf has buf.len()=256 writable bytes and name is null-terminated.
    let len_written = unsafe {
        unsafe_greet(buf.as_mut_ptr(), buf.len(), name.as_ptr())
    };

    if len_written < 0 {
        return Err("Buffer too small or invalid name".to_string());
    }

    String::from_utf8(buf[..len_written as usize].to_vec())
        .map_err(|e| format!("Invalid UTF-8: {e}"))
}

fn main() {
    match safe_greet("Rustacean") {
        Ok(msg) => println!("{msg}"),
        Err(e) => eprintln!("Error: {e}"),
    }
    // Expected output: Hello, Rustacean!
}
```

#tufted.margin-note[
  *Checkpoint*: You can write a thread-safe counter with `Arc<Mutex<T>>`
]

*Checkpoint callback*

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));

    let mut handles = vec![];
    for i in 0..10 {
        let cntr = Arc::clone(&counter);
        handles.push(thread::spawn(move || {
            let mut guard = cntr.lock().unwrap();
            *guard += 1;
        }));
    }

    handles.into_iter().for_each(|h| h.join().unwrap());

    let guard = counter.lock().unwrap();
    println!("Result: {}", *guard);
}
```

Compare with an `Arc<Atomic*>` version:

```rust
use std::sync::{Arc, Mutex};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::thread;
use std::time::Instant;

fn test<F: Fn() -> usize>(name: &str, f: F) {
    print!("Test with {name}: ");
    let start = Instant::now();
    let result: usize = f();
    let duration = start.elapsed();
    println!("result value = {} in {:?}", result, duration);
}

pub fn main() {
    test("Arc<Mutex<usize>>", || {
        let counter = Arc::new(Mutex::new(0usize));
        let mut handles = vec![];
        for _ in 0..10 {
            let cntr = Arc::clone(&counter);
            handles.push(thread::spawn(move || {
                let mut guard = cntr.lock().unwrap();
                *guard += 1;
            }));
        }
        handles.into_iter().for_each(|h| h.join().unwrap());
        let guard = counter.lock().unwrap();
        *guard
    });

    test("Arc<AtomicUsize>", || {
        let counter = Arc::new(AtomicUsize::new(0usize));
        let mut handles = vec![];
        for _ in 0..10 {
            let cntr = Arc::clone(&counter);
            handles.push(thread::spawn(move || {
                cntr.fetch_add(1, Ordering::Relaxed);
            }));
        }
        handles.into_iter().for_each(|h| h.join().unwrap());
        counter.load(Ordering::Relaxed)
    });
}
```
