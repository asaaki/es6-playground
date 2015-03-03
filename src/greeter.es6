import "babelHelpers"

class Greeter {
  hello(person) {
    return "Hello, " + person.firstname + " " + person.lastname + "!";
  }
}

export {Greeter}
