require 'yaml'

class TravisYmlBuilder < Jenkins::Tasks::Builder
  display_name "Build using .travis.yml"

  def initialize(attrs = {})
  end

  ##
  # Runs before the build begins
  #
  # @param [Jenkins::Model::Build] build the build which will begin
  # @param [Jenkins::Model::Listener] listener the listener for this build.
  def prebuild(build, listener)
  end

  ##
  # Runs the step over the given build and reports the progress to the listener.
  #
  # @param [Jenkins::Model::Build] build on which to run this step
  # @param [Jenkins::Launcher] launcher the launcher that can run code on the node running this build
  # @param [Jenkins::Model::Listener] listener the listener for this build.
  def perform(build, launcher, listener)
    ws = build.workspace
    script, after_success, after_failure = generate_travis_yml_runner(ws)

    opts = { :chdir => ws, :out => listener }
    ret = execute_script!(launcher, script, opts)

    if ret == 0
      execute_script!(launcher, after_success, opts)
    else
      execute_script!(launcher, after_failure, opts)
      build.abort
    end
  end

  def execute_script!(launcher, script, opts)
    if script && script.exist?
      ret = execute_script(launcher, script, opts)
      script.delete
      ret
    end
  end

  def execute_script(launcher, script, opts)
    if script && script.exist?
      launcher.execute("bash", "-x", script.to_s, opts)
    end
  end

  def generate_travis_yml_runner(dir)
    file = dir.join(".travis.yml")
    yaml = file.native.readToString() # XXX: need Jenkins::FilePath#read
    conf = YAML.load(yaml)

    script = generate_script(dir, conf, %w[ before_install install before_script script after_script ])

    # TODO: after_success, after_failure
    # after_success = generate_script(dir, conf, %w[ after_success ])
    # after_failure = generate_script(dir, conf, %w[ after_failure ])

    return script, nil, nil
  end

  def generate_script(dir, conf, keys = [])
    command = keys.map{|k| conf[k] || [] }.flatten.map(&:to_s).join("\n")

    file = dir.join("hudson.#{now}.sh")
    file.native.write(command, nil) # XXX: need Jenkins::FilePath#write

    file
  end

  def now
    Time.now.instance_eval { '%s.%03d' % [ strftime('%Y%m%d%H%M%S'), (usec/1000.0).round ] }
  end
end
