 struct Lens<Whole, Part> {
    let get: (Whole) -> Part
    let set: (Whole, Part) -> Whole
}

extension Lens {
    static func >>> <InnerPart> (
      l: Lens<Whole, Part>,
      r: Lens<Part, InnerPart>
    ) -> Lens<Whole, InnerPart> {
        return Lens<Whole, InnerPart>(
          get: { r.get(l.get($0)) },
          set: { whole, innerPart in
            let part = l.get(whole)
            return l.set(whole, r.set(part, innerPart))
        })
    }
}
