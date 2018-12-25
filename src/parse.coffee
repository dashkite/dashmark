import {grammar} from "panda-grammar"
import {start} from "./patterns"

class Parser
  @create: -> new Parser
  @parse: (s) -> @create().parse s
  constructor: -> @parse = grammar start()

export {Parser}
