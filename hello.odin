package main

import "core:fmt"
import "core:os"
import "core:strings"

TAPE_SIZE :: 30_000

Interpreter :: struct {
    ip: int,
    dp: int,
    tape: [TAPE_SIZE]byte,
}


interpret :: proc(filepath: string) -> int {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok do return -1
    defer delete(data, context.allocator)

    interpreter := Interpreter{}
    for {
        if interpreter.ip == len(data) do return 0;
        ch: byte = data[interpreter.ip]

        switch ch {
        case '>': interpreter.dp += 1
        case '<': interpreter.dp -= 1
        case '+': interpreter.tape[interpreter.dp] += 1
        case '-': interpreter.tape[interpreter.dp] -= 1
        case '.': fmt.printf("%c", interpreter.tape[interpreter.dp])
        case ',': // implement later
        case '[': 
            if interpreter.tape[interpreter.dp] == 0 {
                for data[interpreter.ip] != ']' do interpreter.ip += 1
            }
        case ']':
            if interpreter.tape[interpreter.dp] != 0 {
                for data[interpreter.ip] != '[' do interpreter.ip -= 1
                continue // skip increment of ip after the switch
            }
        case '\n': // do nothing
        case:
            fmt.printf("Input character '%c' not recognized", ch)
            return -1;
        }

        interpreter.ip += 1
    }

    return 0
}

main :: proc() {
    rc := interpret("hello_world.bf")
}
