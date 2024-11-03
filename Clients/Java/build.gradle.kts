import com.google.protobuf.gradle.id
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

group = "gay.pizza.stable.diffusion"
version = "1.0.0-SNAPSHOT"

plugins {
  `java-library`
  `maven-publish`

  kotlin("jvm") version "2.0.21"
  kotlin("plugin.serialization") version "2.0.21"

  id("com.google.protobuf") version "0.9.4"
}

java {
  withSourcesJar()
}

repositories {
  mavenCentral()
}

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-bom")
  implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0")

  api("io.grpc:grpc-stub:1.68.1")
  api("io.grpc:grpc-protobuf:1.68.1")
  api("io.grpc:grpc-kotlin-stub:1.4.1")
  implementation("com.google.protobuf:protobuf-java:4.28.3")

  implementation("io.grpc:grpc-netty:1.68.1")
}

protobuf {
  protoc {
    artifact = "com.google.protobuf:protoc:4.28.3"
  }

  plugins {
    create("grpc") {
      artifact = "io.grpc:protoc-gen-grpc-java:1.68.1"
    }

    create("grpckt") {
      artifact = "io.grpc:protoc-gen-grpc-kotlin:1.4.1:jdk8@jar"
    }
  }

  generateProtoTasks {
    all().configureEach {
      builtins {
        java {}
        kotlin {}
      }

      plugins {
        id("grpc") {}
        id("grpckt") {}
      }
    }
  }
}

publishing {
  publications {
    create<MavenPublication>("mavenJava") {
      from(components["java"])
    }
  }

  repositories {
    mavenLocal()

    var githubPackagesToken = System.getenv("GITHUB_TOKEN")
    if (githubPackagesToken == null) {
      githubPackagesToken = project.findProperty("github.token") as String?
    }

    maven {
      name = "GitHubPackages"
      url = uri("https://maven.pkg.github.com/gaypizzaspecifications/stable-diffusion-rpc")
      credentials {
        username = project.findProperty("github.username") as String? ?: "gaypizzaspecifications"
        password = githubPackagesToken
      }
    }
  }
}

tasks.withType<Wrapper> {
  gradleVersion = "8.10.2"
}
