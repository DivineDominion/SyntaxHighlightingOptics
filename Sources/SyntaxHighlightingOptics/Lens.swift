 struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Whole, Part) -> Whole
}

infix operator >>>

extension Lens {
    static func >>> <InnerPart> (
      l: Lens<Whole, Part>,
      r: Lens<Part, InnerPart>
    ) -> Lens<Whole, InnerPart> {
        return Lens<Whole, InnerPart>(
          get: { r.get(l.get($0)) },
          set: { a, c in l.set(a, r.set(l.get(a), c)) }
        )
    }
}
