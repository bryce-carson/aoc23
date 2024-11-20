function testLocalVariable(localVariable) {
    localVariable = "a"
    print localVariable
}

END {
    testLocalVariable()
}
