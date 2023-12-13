func recursiveMemoize<Input: Hashable, Output>(_ function: @escaping ((Input) -> Output, Input) -> Output) -> (Input) -> Output {
    var cache: [Input: Output] = [:]

    var memoized: ((Input) -> Output)!
    memoized = { input in
        if let cached = cache[input] {
            return cached
        }

        let result = function(memoized, input)
        cache[input] = result
        return result
    }

    return memoized
}
