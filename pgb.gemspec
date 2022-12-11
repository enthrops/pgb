# frozen_string_literal: true

require_relative 'lib/pgb/version'

Gem::Specification.new do |spec|
  spec.name = 'pgb'
  spec.version = PGB::VERSION
  spec.authors = ['Dmitry Gubitskiy']
  spec.email = ['d.gubitskiy@gmail.com']

  spec.summary = 'Postgres-specific ORM for Ruby'
  spec.homepage = 'https://github.com/enthrops/pgb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7', '< 3.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/enthrops/pgb'
  spec.metadata['changelog_uri'] = 'https://github.com/enthrops/pgb/blob/master/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      regexp = %r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)}
      (f == __FILE__) || f.match(regexp)
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'colorize', '= 0.8.1'
  spec.add_dependency 'pg', '~> 1.4'
  spec.add_dependency 'zeitwerk', '~> 2.6'
end
