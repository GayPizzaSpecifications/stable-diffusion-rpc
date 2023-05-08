//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: jobs.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


///*
/// The job service, for inspecting and monitoring the state of jobs executing on the service.
///
/// Usage: instantiate `SdJobServiceClient`, then call methods of this protocol to make API calls.
public protocol SdJobServiceClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: SdJobServiceClientInterceptorFactoryProtocol? { get }

  func getJob(
    _ request: SdGetJobRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<SdGetJobRequest, SdGetJobResponse>

  func cancelJob(
    _ request: SdCancelJobRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<SdCancelJobRequest, SdCancelJobResponse>

  func streamJobUpdates(
    _ request: SdStreamJobUpdatesRequest,
    callOptions: CallOptions?,
    handler: @escaping (SdJobUpdate) -> Void
  ) -> ServerStreamingCall<SdStreamJobUpdatesRequest, SdJobUpdate>
}

extension SdJobServiceClientProtocol {
  public var serviceName: String {
    return "gay.pizza.stable.diffusion.JobService"
  }

  /// Unary call to GetJob
  ///
  /// - Parameters:
  ///   - request: Request to send to GetJob.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getJob(
    _ request: SdGetJobRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<SdGetJobRequest, SdGetJobResponse> {
    return self.makeUnaryCall(
      path: SdJobServiceClientMetadata.Methods.getJob.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetJobInterceptors() ?? []
    )
  }

  /// Unary call to CancelJob
  ///
  /// - Parameters:
  ///   - request: Request to send to CancelJob.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func cancelJob(
    _ request: SdCancelJobRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<SdCancelJobRequest, SdCancelJobResponse> {
    return self.makeUnaryCall(
      path: SdJobServiceClientMetadata.Methods.cancelJob.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCancelJobInterceptors() ?? []
    )
  }

  /// Server streaming call to StreamJobUpdates
  ///
  /// - Parameters:
  ///   - request: Request to send to StreamJobUpdates.
  ///   - callOptions: Call options.
  ///   - handler: A closure called when each response is received from the server.
  /// - Returns: A `ServerStreamingCall` with futures for the metadata and status.
  public func streamJobUpdates(
    _ request: SdStreamJobUpdatesRequest,
    callOptions: CallOptions? = nil,
    handler: @escaping (SdJobUpdate) -> Void
  ) -> ServerStreamingCall<SdStreamJobUpdatesRequest, SdJobUpdate> {
    return self.makeServerStreamingCall(
      path: SdJobServiceClientMetadata.Methods.streamJobUpdates.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStreamJobUpdatesInterceptors() ?? [],
      handler: handler
    )
  }
}

#if compiler(>=5.6)
@available(*, deprecated)
extension SdJobServiceClient: @unchecked Sendable {}
#endif // compiler(>=5.6)

@available(*, deprecated, renamed: "SdJobServiceNIOClient")
public final class SdJobServiceClient: SdJobServiceClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: SdJobServiceClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: SdJobServiceClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the gay.pizza.stable.diffusion.JobService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SdJobServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct SdJobServiceNIOClient: SdJobServiceClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: SdJobServiceClientInterceptorFactoryProtocol?

  /// Creates a client for the gay.pizza.stable.diffusion.JobService service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SdJobServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

#if compiler(>=5.6)
///*
/// The job service, for inspecting and monitoring the state of jobs executing on the service.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol SdJobServiceAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: SdJobServiceClientInterceptorFactoryProtocol? { get }

  func makeGetJobCall(
    _ request: SdGetJobRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<SdGetJobRequest, SdGetJobResponse>

  func makeCancelJobCall(
    _ request: SdCancelJobRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<SdCancelJobRequest, SdCancelJobResponse>

  func makeStreamJobUpdatesCall(
    _ request: SdStreamJobUpdatesRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncServerStreamingCall<SdStreamJobUpdatesRequest, SdJobUpdate>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SdJobServiceAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return SdJobServiceClientMetadata.serviceDescriptor
  }

  public var interceptors: SdJobServiceClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeGetJobCall(
    _ request: SdGetJobRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<SdGetJobRequest, SdGetJobResponse> {
    return self.makeAsyncUnaryCall(
      path: SdJobServiceClientMetadata.Methods.getJob.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetJobInterceptors() ?? []
    )
  }

  public func makeCancelJobCall(
    _ request: SdCancelJobRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<SdCancelJobRequest, SdCancelJobResponse> {
    return self.makeAsyncUnaryCall(
      path: SdJobServiceClientMetadata.Methods.cancelJob.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCancelJobInterceptors() ?? []
    )
  }

  public func makeStreamJobUpdatesCall(
    _ request: SdStreamJobUpdatesRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncServerStreamingCall<SdStreamJobUpdatesRequest, SdJobUpdate> {
    return self.makeAsyncServerStreamingCall(
      path: SdJobServiceClientMetadata.Methods.streamJobUpdates.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStreamJobUpdatesInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SdJobServiceAsyncClientProtocol {
  public func getJob(
    _ request: SdGetJobRequest,
    callOptions: CallOptions? = nil
  ) async throws -> SdGetJobResponse {
    return try await self.performAsyncUnaryCall(
      path: SdJobServiceClientMetadata.Methods.getJob.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetJobInterceptors() ?? []
    )
  }

  public func cancelJob(
    _ request: SdCancelJobRequest,
    callOptions: CallOptions? = nil
  ) async throws -> SdCancelJobResponse {
    return try await self.performAsyncUnaryCall(
      path: SdJobServiceClientMetadata.Methods.cancelJob.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeCancelJobInterceptors() ?? []
    )
  }

  public func streamJobUpdates(
    _ request: SdStreamJobUpdatesRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncResponseStream<SdJobUpdate> {
    return self.performAsyncServerStreamingCall(
      path: SdJobServiceClientMetadata.Methods.streamJobUpdates.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeStreamJobUpdatesInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct SdJobServiceAsyncClient: SdJobServiceAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: SdJobServiceClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: SdJobServiceClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

#endif // compiler(>=5.6)

public protocol SdJobServiceClientInterceptorFactoryProtocol: GRPCSendable {

  /// - Returns: Interceptors to use when invoking 'getJob'.
  func makeGetJobInterceptors() -> [ClientInterceptor<SdGetJobRequest, SdGetJobResponse>]

  /// - Returns: Interceptors to use when invoking 'cancelJob'.
  func makeCancelJobInterceptors() -> [ClientInterceptor<SdCancelJobRequest, SdCancelJobResponse>]

  /// - Returns: Interceptors to use when invoking 'streamJobUpdates'.
  func makeStreamJobUpdatesInterceptors() -> [ClientInterceptor<SdStreamJobUpdatesRequest, SdJobUpdate>]
}

public enum SdJobServiceClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "JobService",
    fullName: "gay.pizza.stable.diffusion.JobService",
    methods: [
      SdJobServiceClientMetadata.Methods.getJob,
      SdJobServiceClientMetadata.Methods.cancelJob,
      SdJobServiceClientMetadata.Methods.streamJobUpdates,
    ]
  )

  public enum Methods {
    public static let getJob = GRPCMethodDescriptor(
      name: "GetJob",
      path: "/gay.pizza.stable.diffusion.JobService/GetJob",
      type: GRPCCallType.unary
    )

    public static let cancelJob = GRPCMethodDescriptor(
      name: "CancelJob",
      path: "/gay.pizza.stable.diffusion.JobService/CancelJob",
      type: GRPCCallType.unary
    )

    public static let streamJobUpdates = GRPCMethodDescriptor(
      name: "StreamJobUpdates",
      path: "/gay.pizza.stable.diffusion.JobService/StreamJobUpdates",
      type: GRPCCallType.serverStreaming
    )
  }
}

///*
/// The job service, for inspecting and monitoring the state of jobs executing on the service.
///
/// To build a server, implement a class that conforms to this protocol.
public protocol SdJobServiceProvider: CallHandlerProvider {
  var interceptors: SdJobServiceServerInterceptorFactoryProtocol? { get }

  func getJob(request: SdGetJobRequest, context: StatusOnlyCallContext) -> EventLoopFuture<SdGetJobResponse>

  func cancelJob(request: SdCancelJobRequest, context: StatusOnlyCallContext) -> EventLoopFuture<SdCancelJobResponse>

  func streamJobUpdates(request: SdStreamJobUpdatesRequest, context: StreamingResponseCallContext<SdJobUpdate>) -> EventLoopFuture<GRPCStatus>
}

extension SdJobServiceProvider {
  public var serviceName: Substring {
    return SdJobServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "GetJob":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdGetJobRequest>(),
        responseSerializer: ProtobufSerializer<SdGetJobResponse>(),
        interceptors: self.interceptors?.makeGetJobInterceptors() ?? [],
        userFunction: self.getJob(request:context:)
      )

    case "CancelJob":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdCancelJobRequest>(),
        responseSerializer: ProtobufSerializer<SdCancelJobResponse>(),
        interceptors: self.interceptors?.makeCancelJobInterceptors() ?? [],
        userFunction: self.cancelJob(request:context:)
      )

    case "StreamJobUpdates":
      return ServerStreamingServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdStreamJobUpdatesRequest>(),
        responseSerializer: ProtobufSerializer<SdJobUpdate>(),
        interceptors: self.interceptors?.makeStreamJobUpdatesInterceptors() ?? [],
        userFunction: self.streamJobUpdates(request:context:)
      )

    default:
      return nil
    }
  }
}

#if compiler(>=5.6)

///*
/// The job service, for inspecting and monitoring the state of jobs executing on the service.
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol SdJobServiceAsyncProvider: CallHandlerProvider {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: SdJobServiceServerInterceptorFactoryProtocol? { get }

  @Sendable func getJob(
    request: SdGetJobRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> SdGetJobResponse

  @Sendable func cancelJob(
    request: SdCancelJobRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> SdCancelJobResponse

  @Sendable func streamJobUpdates(
    request: SdStreamJobUpdatesRequest,
    responseStream: GRPCAsyncResponseStreamWriter<SdJobUpdate>,
    context: GRPCAsyncServerCallContext
  ) async throws
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension SdJobServiceAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return SdJobServiceServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return SdJobServiceServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: SdJobServiceServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "GetJob":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdGetJobRequest>(),
        responseSerializer: ProtobufSerializer<SdGetJobResponse>(),
        interceptors: self.interceptors?.makeGetJobInterceptors() ?? [],
        wrapping: self.getJob(request:context:)
      )

    case "CancelJob":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdCancelJobRequest>(),
        responseSerializer: ProtobufSerializer<SdCancelJobResponse>(),
        interceptors: self.interceptors?.makeCancelJobInterceptors() ?? [],
        wrapping: self.cancelJob(request:context:)
      )

    case "StreamJobUpdates":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<SdStreamJobUpdatesRequest>(),
        responseSerializer: ProtobufSerializer<SdJobUpdate>(),
        interceptors: self.interceptors?.makeStreamJobUpdatesInterceptors() ?? [],
        wrapping: self.streamJobUpdates(request:responseStream:context:)
      )

    default:
      return nil
    }
  }
}

#endif // compiler(>=5.6)

public protocol SdJobServiceServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'getJob'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGetJobInterceptors() -> [ServerInterceptor<SdGetJobRequest, SdGetJobResponse>]

  /// - Returns: Interceptors to use when handling 'cancelJob'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeCancelJobInterceptors() -> [ServerInterceptor<SdCancelJobRequest, SdCancelJobResponse>]

  /// - Returns: Interceptors to use when handling 'streamJobUpdates'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeStreamJobUpdatesInterceptors() -> [ServerInterceptor<SdStreamJobUpdatesRequest, SdJobUpdate>]
}

public enum SdJobServiceServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "JobService",
    fullName: "gay.pizza.stable.diffusion.JobService",
    methods: [
      SdJobServiceServerMetadata.Methods.getJob,
      SdJobServiceServerMetadata.Methods.cancelJob,
      SdJobServiceServerMetadata.Methods.streamJobUpdates,
    ]
  )

  public enum Methods {
    public static let getJob = GRPCMethodDescriptor(
      name: "GetJob",
      path: "/gay.pizza.stable.diffusion.JobService/GetJob",
      type: GRPCCallType.unary
    )

    public static let cancelJob = GRPCMethodDescriptor(
      name: "CancelJob",
      path: "/gay.pizza.stable.diffusion.JobService/CancelJob",
      type: GRPCCallType.unary
    )

    public static let streamJobUpdates = GRPCMethodDescriptor(
      name: "StreamJobUpdates",
      path: "/gay.pizza.stable.diffusion.JobService/StreamJobUpdates",
      type: GRPCCallType.serverStreaming
    )
  }
}
