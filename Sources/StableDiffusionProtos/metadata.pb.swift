// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: metadata.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

///*
/// Server metadata for the Stable Diffusion RPC service.

import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public enum SdServerRole: SwiftProtobuf.Enum, Swift.CaseIterable {
  public typealias RawValue = Int
  case unknownRole // = 0
  case node // = 1
  case coordinator // = 2
  case UNRECOGNIZED(Int)

  public init() {
    self = .unknownRole
  }

  public init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .unknownRole
    case 1: self = .node
    case 2: self = .coordinator
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  public var rawValue: Int {
    switch self {
    case .unknownRole: return 0
    case .node: return 1
    case .coordinator: return 2
    case .UNRECOGNIZED(let i): return i
    }
  }

  // The compiler won't synthesize support with the UNRECOGNIZED case.
  public static let allCases: [SdServerRole] = [
    .unknownRole,
    .node,
    .coordinator,
  ]

}

public struct SdServerMetadata: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var role: SdServerRole = .unknownRole

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct SdGetServerMetadataRequest: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}
}

public struct SdGetServerMetadataResponse: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var metadata: SdServerMetadata {
    get {return _metadata ?? SdServerMetadata()}
    set {_metadata = newValue}
  }
  /// Returns true if `metadata` has been explicitly set.
  public var hasMetadata: Bool {return self._metadata != nil}
  /// Clears the value of `metadata`. Subsequent reads from it will return its default value.
  public mutating func clearMetadata() {self._metadata = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _metadata: SdServerMetadata? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "gay.pizza.stable.diffusion"

extension SdServerRole: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "unknown_role"),
    1: .same(proto: "node"),
    2: .same(proto: "coordinator"),
  ]
}

extension SdServerMetadata: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".ServerMetadata"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "role"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.role) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.role != .unknownRole {
      try visitor.visitSingularEnumField(value: self.role, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: SdServerMetadata, rhs: SdServerMetadata) -> Bool {
    if lhs.role != rhs.role {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SdGetServerMetadataRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".GetServerMetadataRequest"
  public static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    // Load everything into unknown fields
    while try decoder.nextFieldNumber() != nil {}
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: SdGetServerMetadataRequest, rhs: SdGetServerMetadataRequest) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SdGetServerMetadataResponse: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".GetServerMetadataResponse"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "metadata"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._metadata) }()
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._metadata {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: SdGetServerMetadataResponse, rhs: SdGetServerMetadataResponse) -> Bool {
    if lhs._metadata != rhs._metadata {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
