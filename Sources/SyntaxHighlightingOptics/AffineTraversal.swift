/// A box type for ``Lens`` and ``Prism``.
struct AffineTraversal<Whole, Part> {
    let tryGet: (Whole) -> Part?
    let set: (Whole, Part) -> Whole
}

extension AffineTraversal {
    init(lens: Lens<Whole, Part>) {
        self.init(
          tryGet: lens.get,
          set: lens.set)
    }

    init(prism: Prism<Whole, Part>) {
        self.init(
          tryGet: prism.tryGet,
          set: { _, part in prism.inject(part) })
    }
}

infix operator >>>

extension Lens {
    fileprivate var asAffineTraversal: AffineTraversal<Whole, Part> {
        .init(lens: self)
    }
}

extension Prism {
    fileprivate var asAffineTraversal: AffineTraversal<Whole, Part> {
        .init(prism: self)
    }
}

extension AffineTraversal {
    static func >>> <InnerPart> (
      l: AffineTraversal<Whole, Part>,
      r: AffineTraversal<Part, InnerPart>
    ) -> AffineTraversal<Whole, InnerPart> {
        return AffineTraversal<Whole, InnerPart>(
          tryGet: { l.tryGet($0).flatMap(r.tryGet) },
          set: { whole, innerPart in
            guard let part = l.tryGet(whole) else { return whole }
            return l.set(whole, r.set(part, innerPart))
        })
    }

    static func >>> <InnerPart> (
      l: AffineTraversal<Whole, Part>,
      r: Lens<Part, InnerPart>
    ) -> AffineTraversal<Whole, InnerPart> {
        return l >>> .init(lens: r)
    }

    static func >>> <InnerPart> (
      l: Lens<Whole, Part>,
      r: AffineTraversal<Part, InnerPart>
    ) -> AffineTraversal<Whole, InnerPart> {
        return .init(lens: l) >>> r
    }

    static func >>> <InnerPart> (
      l: AffineTraversal<Whole, Part>,
      r: Prism<Part, InnerPart>
    ) -> AffineTraversal<Whole, InnerPart> {
        return l >>> .init(prism: r)
    }

    static func >>> <InnerPart> (
      l: Prism<Whole, Part>,
      r: AffineTraversal<Part, InnerPart>
    ) -> AffineTraversal<Whole, InnerPart> {
        return .init(prism: l) >>> r
    }
}
