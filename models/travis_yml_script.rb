require 'yaml'
require 'shellwords'

class TravisYmlScript
  def initialize(attrs = {})
    @cmds = []
    @file = attrs[:file]
    @environment = attrs[:environment]
  end

  def build
    reset

    conf = YAML.load(@file.read)
    expand_env(@environment)
    build_env(conf)
    build_proc(%w[before_install install before_script script], conf)
    build_result(conf)
    build_proc(%w[before_deploy deploy after_deploy after_script], conf)
  end

  def to_s
    [ header, @cmds, footer ].flatten.join("\n")
  end

  private

  def header
    return %{
              #!/usr/bin/env bash

              capture_result() {
                local result=$1
                export TRAVIS_JENKINS_RESULT=$(( ${TRAVIS_JENKINS_RESULT:-0} | $(($result != 0)) ))
              }

              export CI=1
              export CONTINUOUS_INTEGRATION=1
              export TRAVIS_JENKINS_RESULT=0
            }
  end

  def footer
    return %{
              exit $TRAVIS_JENKINS_RESULT
            }
  end

  def reset
    @cmds = []
  end

  def expand_env(env)
    env.each do |key,value|
      export(key+"="+Shellwords.shellescape(value))
    end
  end

  def build_env(conf)
    values(conf, "env").each do |env|
      export(env)
    end
  end

  def builder(phases,conf, &commandList)
    phases.each do |k|
      values(conf, k).each do |cmd|
        run_if("$TRAVIS_JENKINS_RESULT -eq 0") do
          commandList.call(cmd)
        end
      end
    end
  end

  def build_proc(phases,conf)
    builder(phases,
          conf){ |cmd|
            echo(cmd)
            run(cmd)
            capture_result
          }
  end

  def build_result(conf)
    builder(%w[after_success after_failure],
          conf){ |cmd|
            echo(cmd)
            run(cmd)
            capture_result
          }
  end

  def values(conf, key)
    [ conf[key] || [] ].flatten.map(&:to_s)
  end

  def export(cmd)
    run("export #{cmd}")
  end

  def echo(cmd)
    run("echo $" + Shellwords.shellescape(cmd))
  end

  def capture_result
    run("capture_result $?")
  end

  def run(cmd)
    @cmds.push(cmd)
  end

  def run_if(cond)
    if block_given?
      run("if [ #{cond} ]; then")
      yield
      run("fi")
    end
  end
end
