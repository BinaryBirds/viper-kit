//
//  ViperTemplateScopesMiddleware.swift
//  ViperKit
//
//  Created by Tibor Bodecs on 2020. 11. 21..
//

public struct ViperTemplateScopesMiddleware: Middleware {

    public init() {}

    public func respond(to req: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        do {
            for module in req.application.viper.modules {
                if let generator = module.templateDataGenerator(for: req) {
                    try req.tau.context.register(generators: generator, toScope: module.name)
                }
            }
        }
        catch {
            return req.eventLoop.makeFailedFuture(error)
        }
        return next.respond(to: req)
    }
}
