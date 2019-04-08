Pod::Spec.new do |s|
  s.name          = 'Cordate'
  s.version       = '3.0.0'
  s.license       = 'MIT'
  s.summary       = 'Give dates a special place in your ❤️'
  s.description   = 'Cordate is a small library which makes working with dates much smoother by adding commonly-used extensions, custom UI components, and more.'
  s.author        = 'Duet Health'
  s.source        = { git: 'https://github.com/DuetHealth/Cordate.git', tag: s.version }
  s.homepage      = s.source[:git]
  s.ios.deployment_target = '9.0'
  s.requires_arc  = true
  s.default_subspec = 'Core'
  s.swift_version = '5.0'

  s.subspec 'Core' do |core|
    core.source_files = 'Cordate/Sources/Core/**/*.{h,m,swift}'
  end

  s.subspec 'Rx' do |rx|
    rx.source_files = 'Cordate/Sources/**/*.{h,m,swift}'

    rx.dependency 'RxCocoa'
    rx.dependency 'RxSwift'
  end

end
