// Equivalent of Kotlin's sealed class Resource<T>
enum Resource<T> {
    case loading
    case success(T)
    case error(String)
}

extension Resource {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .error(let msg) = self { return msg }
        return nil
    }

    var successValue: T? {
        if case .success(let val) = self { return val }
        return nil
    }
}
