//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: tokenizer.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


///*
/// The tokenizer service, for analyzing tokens for a loaded model.
///
/// Usage: instantiate `SdTokenizerServiceClient`, then call methods of this protocol to make API calls.
public protocol SdTokenizerServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? { get }

  func tokenize(
    _ request: SdTokenizeRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<SdTokenizeRequest, SdTokenizeResponse>
}

extension SdTokenizerServiceClientProtocol {
  public var serviceName: String {
    return "gay.pizza.stable.diffusion.TokenizerService"
  }

  ///*
  /// Analyze the input using a loaded model and return the results.
  ///
  /// - Parameters:
  ///   - request: Request to send to Tokenize.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func tokenize(
    _ request: SdTokenizeRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<SdTokenizeRequest, SdTokenizeResponse> {
    return self.makeUnaryCall(
      path: SdTokenizerServiceClientMetadata.Methods.tokenize.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeTokenizeInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension SdTokenizerServiceClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "SdTokenizerServiceNIOClient")
public final class SdTokenizerServiceClient: SdTokenizerServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the gay.pizza.stable.diffusion.TokenizerService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct SdTokenizerServiceNIOClient: SdTokenizerServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the gay.pizza.stable.diffusion.TokenizerService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

///*
/// The tokenizer service, for analyzing tokens for a loaded model.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol SdTokenizerServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? { get }

  func makeTokenizeCall(
    _ request: SdTokenizeRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<SdTokenizeRequest, SdTokenizeResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SdTokenizerServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return SdTokenizerServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeTokenizeCall(
    _ request: SdTokenizeRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<SdTokenizeRequest, SdTokenizeResponse> {
    return self.makeAsyncUnaryCall(
      path: SdTokenizerServiceClientMetadata.Methods.tokenize.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeTokenizeInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SdTokenizerServiceAsyncClientProtocol {
  public func tokenize(
    _ request: SdTokenizeRequest,
    callOptions: CallOptions? = nil
  ) async throws -> SdTokenizeResponse {
    return try await self.performAsyncUnaryCall(
      path: SdTokenizerServiceClientMetadata.Methods.tokenize.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeTokenizeInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct SdTokenizerServiceAsyncClient: SdTokenizerServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SdTokenizerServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol SdTokenizerServiceClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'tokenize'.
  func makeTokenizeInterceptors() -> [ClientInterceptor<SdTokenizeRequest, SdTokenizeResponse>]
}

public enum SdTokenizerServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "TokenizerService",
    fullName: "gay.pizza.stable.diffusion.TokenizerService",
    methods: [
      SdTokenizerServiceClientMetadata.Methods.tokenize,
    ]
  )

  public enum Methods {
    public static let tokenize = GRPCMethodDescriptor(
      name: "Tokenize",
      path: "/gay.pizza.stable.diffusion.TokenizerService/Tokenize",
      type: GRPCCallType.unary
    )
  }
}

///*
/// The tokenizer service, for analyzing tokens for a loaded model.
///
/// To build a server, implement a class that conforms to this protocol.
public protocol SdTokenizerServiceProvider: CallHandlerProvider {
  var interceptors: SdTokenizerServiceServerInterceptorFactoryProtocol? { get }

  ///*
  /// Analyze the input using a loaded model and return the results.
  func tokenize(request: SdTokenizeRequest, context: StatusOnlyCallContext) -> EventLoopFuture<SdTokenizeResponse>
}

extension SdTokenizerServiceProvider {
  public var serviceName: Substring {
    return SdTokenizerServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Tokenize":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdTokenizeRequest>(),
        responseSerializer: ProtobufSerializer<SdTokenizeResponse>(),
        interceptors: self.interceptors?.makeTokenizeInterceptors() ?? [],
        userFunction: self.tokenize(request:context:)
      )

    default:
      return nil
    }
  }
}

///*
/// The tokenizer service, for analyzing tokens for a loaded model.
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol SdTokenizerServiceAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: SdTokenizerServiceServerInterceptorFactoryProtocol? { get }

  ///*
  /// Analyze the input using a loaded model and return the results.
  func tokenize(
    request: SdTokenizeRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> SdTokenizeResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SdTokenizerServiceAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return SdTokenizerServiceServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return SdTokenizerServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: SdTokenizerServiceServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "Tokenize":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdTokenizeRequest>(),
        responseSerializer: ProtobufSerializer<SdTokenizeResponse>(),
        interceptors: self.interceptors?.makeTokenizeInterceptors() ?? [],
        wrapping: { try await self.tokenize(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

public protocol SdTokenizerServiceServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'tokenize'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeTokenizeInterceptors() -> [ServerInterceptor<SdTokenizeRequest, SdTokenizeResponse>]
}

public enum SdTokenizerServiceServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "TokenizerService",
    fullName: "gay.pizza.stable.diffusion.TokenizerService",
    methods: [
      SdTokenizerServiceServerMetadata.Methods.tokenize,
    ]
  )

  public enum Methods {
    public static let tokenize = GRPCMethodDescriptor(
      name: "Tokenize",
      path: "/gay.pizza.stable.diffusion.TokenizerService/Tokenize",
      type: GRPCCallType.unary
    )
  }
}