import Combine
import SwiftUI

public extension AppRouter {
    struct SheetRoute: Identifiable {
        public var id: Route {
            self.route
        }
        
        let route: Route
        let presentation: Set<PresentationDetent>
        
        public init(
            route: Route,
            presentation: Set<PresentationDetent>
        ) {
            self.route = route
            self.presentation = presentation
        }
    }
}

public extension AppRouter {
    class StackController: ObservableObject {
        @Published
        var path: NavigationPath
        
        var currentRoute: Route? {
            Self.lastRoute(from: self.path)
        }
        
        @Published
        var sheetRoute: SheetRoute?
        
        @Published
        var fullScreenCoverRoute: Route?
        
        var dismissStack: DismissAction
        
        public init(
            path: NavigationPath = NavigationPath(),
            dismiss: DismissAction
        ) {
            self.path = path
            self.dismissStack = dismiss
        }
        
        public func pop() {
            guard canGoBack() else { return }
            
            path.removeLast()
        }
        
        public func pop(to route: Route) {
            guard canGoBack() else { return }
            
            self.path.removeLast(getRouteIndex(from: self.path, route: route))
        }
        
        public func reset() {
            self.path = .init()
        }
        
        public func canGoBack() -> Bool {
            self.path.isEmpty == false
        }
        
        public func push(route: Route) {
            self.path.append(route)
        }
        
        public func present(route: Route, with presentation: Set<PresentationDetent>) {
            self.sheetRoute = .init(
                route: route,
                presentation: presentation
            )
        }
        
        public func presentFullScreenCover(route: Route) {
            self.fullScreenCoverRoute = route
        }
        
        public func dismiss() {
            self.dismissStack()
        }
        
        public func dismissSheet() {
            self.sheetRoute = nil
        }
        
        public func dismissFullScreenCover() {
            self.fullScreenCoverRoute = nil
        }
    }
}


extension AppRouter.StackController {
    // FIXME: Theres a way to clean this up a bit
    static func lastRoute(from path: NavigationPath) -> Route? {
        guard
            let pathData = try? JSONEncoder().encode(path.codable),
            let pathArr = try? JSONDecoder().decode([String].self, from: pathData),
            pathArr.count >= 2,
            let data = pathArr[1].data(using: .utf8),
            let route = try? JSONDecoder().decode(Route.self, from: data)
        else {
            return nil
        }
        
        return route
    }
    
    private func getRouteIndex(from path: NavigationPath, route: Route) -> Int {
        guard
            let pathData = try? JSONEncoder().encode(path.codable),
            let pathArr = try? JSONDecoder().decode([String].self, from: pathData),
            pathArr.count >= 2
        else {
            return path.count
        }
        
        let dataArr = pathArr.map({ $0.data(using: .utf8) })
        let routeArr = dataArr.map({ try? JSONDecoder().decode(Route.self, from: $0 ?? Data()) })
        guard let routeIndex = routeArr.compactMap({ $0 }).lastIndex(where: { $0 == route }) else { return path.count }
        return routeIndex
    }
}

