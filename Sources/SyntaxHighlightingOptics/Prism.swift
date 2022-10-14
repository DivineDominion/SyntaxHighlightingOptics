struct Prism<Whole, Part> {
    let tryGet: (Whole) -> Part?
    let inject: (Part) -> Whole
}

extension Prism {
    static func >>> <InnerPart> (
      l: Prism<Whole, Part>,
      r: Prism<Part, InnerPart>
    ) -> Prism<Whole, InnerPart> {
        return Prism<Whole, InnerPart>(
          tryGet: { l.tryGet($0).flatMap(r.tryGet) },
          inject: { l.inject(r.inject($0)) }
        )
    }
}
