import {parse} from "./parse"
import {render} from "./render"

convert = (text) -> render parse text

export {convert}
