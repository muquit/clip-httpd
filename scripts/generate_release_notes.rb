#!/usr/bin/env ruby
########################################################################
# Generate GitHub Release Notes with archive table
# By Claude AI Sonnet 4.5
# Oct-07-2025 
########################################################################
class GenGithubReleaseMD
  PLATFORM_MAP = {
    'darwin' => 'macOS',
    'linux' => 'Linux',
    'windows' => 'Windows',
    'raspberry-pi' => 'Linux',
    'raspberry-pi-jessie' => 'Linux'
  }

  ARCH_MAP = {
    'amd64' => 'x86_64',
    'arm64' => 'ARM64',
    'arm' => 'ARM',
    '386' => 'x86 (32-bit)',
    'raspberry-pi' => 'ARM (Pi)',
    'raspberry-pi-jessie' => 'ARM (Pi Jessie)'
  }

  def initialize
    $stdout.sync = true
    $stderr.sync = true
    @version = nil
    @release_message = nil
    @archives = []
  end

  def log(msg)
    t = Time.new()
    puts "#{t}: #{msg}"
  end

  def read_version
    version_file = 'VERSION'
    unless File.exist?(version_file)
      log "ERROR: VERSION file not found"
      exit 1
    end
    
    @version = File.read(version_file).strip
    log "Version: #{@version}"
  end

  def get_release_message
    @release_message = ARGV[0] || "Bug fixes and improvements"
    log "Release message: #{@release_message}"
  end

  def scan_archives
    bin_dir = 'bin'
    unless Dir.exist?(bin_dir)
      log "ERROR: bin/ directory not found"
      exit 1
    end

    files = Dir.glob("#{bin_dir}/*").select do |f|
      File.file?(f) && (f.end_with?('.tar.gz') || f.end_with?('.zip')) && !f.include?('checksums')
    end

    log "Found #{files.length} archives"

    files.each do |file|
      archive = parse_archive(File.basename(file))
      @archives << archive if archive
    end

    @archives.sort_by! { |a| a[:filename] }
    log "Parsed #{@archives.length} archives"
  end

  def parse_archive(filename)
    # Remove extension
    name = filename.sub(/\.(tar\.gz|zip)$/, '')
    
    # Remove .d suffix
    name = name.sub(/\.d$/, '')

    # Split by version to separate component from platform-arch
    parts = name.split('-')
    
    # Find version index (starts with 'v')
    version_idx = parts.index { |p| p.start_with?('v') }
    return nil unless version_idx

    component = parts[0...version_idx].join('-')
    version = parts[version_idx]
    platform_arch = parts[(version_idx + 1)..-1]

    return nil if platform_arch.nil? || platform_arch.empty?

    # Determine platform and architecture
    platform_str = platform_arch.join('-')
    
    # Check for special cases (raspberry-pi variants)
    if platform_str == 'raspberry-pi' || platform_str == 'raspberry-pi-jessie'
      platform = PLATFORM_MAP[platform_str]
      arch = ARCH_MAP[platform_str]
    else
      # Standard case: platform-arch
      platform_name = platform_arch[0]
      arch_name = platform_arch[1..-1].join('-')
      
      platform = PLATFORM_MAP[platform_name] || platform_name
      arch = arch_name.empty? ? '' : (ARCH_MAP[arch_name] || arch_name)
    end

    {
      filename: filename,
      component: component,
      version: version,
      platform: platform,
      architecture: arch
    }
  end

  def generate_markdown
    md = []
    md << "# Release #{@version}"
    md << ""
    md << "#{@release_message}."
    md << ""
    md << "Please see [ChangeLog](ChangeLog.md) for details."
    md << ""
    md << "Please see the **Installation** section in [README.md](README.md#installation) for installation and checksum verification instructions."
    md << ""
    md << "**Note for Windows users:** Microsoft Edge may flag Go binaries as potentially harmful due to false positives in its virus detection software. This is a known issue with Go-compiled executables. Please use Chrome or Firefox to download, or review the source code and build it yourself if you prefer. Building from source is simple - download Go from https://go.dev/ (no other tools required) and run the build commands."
    md << ""
    md << "## Archives"
    md << ""
    md << "| Archive | Platform | Architecture | Notes |"
    md << "|---------|----------|--------------|-------|"
    
    @archives.each do |archive|
      md << "| #{archive[:filename]} | #{archive[:platform]} | #{archive[:architecture]} | |"
    end

    v=`go-xbuild-go -version`.chomp

    md << "\n\nCross-compiled and released with [go-xbuild-go](https://github.com/muquit/go-xbuild-go) #{v}"

    md.join("\n") + "\n"
  end

  def write_output
    output_file = '/tmp/release_notes.md'
    content = generate_markdown
    
    File.write(output_file, content)
    log "Release notes written to #{output_file}"
  end

  def doit
    log "starting---"
    read_version
    get_release_message
    scan_archives
    write_output
    log "ending---"
  end
end

if __FILE__ == $0
  GenGithubReleaseMD.new.doit()
end
