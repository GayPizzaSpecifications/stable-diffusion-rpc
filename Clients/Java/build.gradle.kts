import com.google.protobuf.gradle.id
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

group = "gay.pizza.stable.diffusion"
version = "1.0.0-SNAPSHOT"

plugins {
  `java-library`
  `maven-publish`

  kotlin("jvm") version "1.8.20"
  kotlin("plugin.serialization") version "1.8.20"

  id("com.google.protobuf") version "0.9.2"
}

repositories {
  mavenCentral()
}

java {
  val javaVersion = JavaVersion.toVersion(17)
  sourceCompatibility = javaVersion
  targetCompatibility = javaVersion

  withSourcesJar()
}

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-bom")
  implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.0-RC")

  api("io.grpc:grpc-stub:1.54.1")
  api("io.grpc:grpc-protobuf:1.54.1")
  api("io.grpc:grpc-kotlin-stub:1.3.0")
  implementation("com.google.protobuf:protobuf-java:3.22.3")

  implementation("io.grpc:grpc-netty:1.54.1")
}

protobuf {
  protoc {
    artifact = "com.google.protobuf:protoc:3.22.3"
  }

  plugins {
    create("grpc") {
      artifact = "io.grpc:protoc-gen-grpc-java:1.54.1"
    }

    create("grpckt") {
      artifact = "io.grpc:protoc-gen-grpc-kotlin:1.3.0:jdk8@jar"
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

tasks.withType<KotlinCompile> {
  kotlinOptions.jvmTarget = "17"
}

tasks.withType<Wrapper> {
  gradleVersion = "8.1.1"
}
