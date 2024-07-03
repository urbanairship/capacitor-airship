require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name = 'UaCapacitorAirship'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = package['repository']['url']
  s.author = package['author']
  s.source = { :git => package['repository']['url'], :tag => s.version.to_s }
  s.ios.deployment_target  = '14.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.1'
  s.dependency "AirshipFrameworkProxy", "7.0.0"
  s.default_subspecs = ["Bootloader", "Plugin"]


  s.subspec "Bootloader" do |bootloader|
    bootloader.source_files = 'ios/Bootloader/**/*.{swift,h,m,c,cc,mm,cpp}'
  end


  s.subspec "Plugin" do |plugin|
    plugin.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
  end
end
