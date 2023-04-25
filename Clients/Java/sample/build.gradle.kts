plugins {
  application

  kotlin("jvm")
  kotlin("plugin.serialization")
}

repositories {
  mavenCentral()
}

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-bom")
  implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.0-RC")

  implementation(rootProject)
}

java {
  val javaVersion = JavaVersion.toVersion(17)
  sourceCompatibility = javaVersion
  targetCompatibility = javaVersion
}

application {
  mainClass.set("gay.pizza.stable.diffusion.sample.MainKt")
}
