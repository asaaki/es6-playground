import "babelHelpers"
import {Greeter} from "greeter"
import {Person} from "models/person"

export default function run() {
  const greeter = new Greeter
  const person  = new Person("Anna", "Bell")
  let result    = greeter.hello(person)

  console.log(result)
}
