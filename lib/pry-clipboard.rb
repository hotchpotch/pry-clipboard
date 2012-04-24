
require 'pry'
require 'clipboard'
require "pry-clipboard/version"

module PryClipboard
  Command = Pry::CommandSet.new do
    create_command "copy-history" do
      description "Copy history to clipboard"

      banner <<-BANNER
          Usage: copy-history [-r] [-q|--quiet]

          e.g: `copy-history`
          e.g: `copy-history -r`
      BANNER

      def options(opt)
        opt.on :r, "Copy history with last result", :optional => true
        opt.on :q, :quiet, "quiet output", :optional => true
      end

      def process
        str = _pry_.input_array[-1] || ''
        str += "#=> #{_pry_.last_result}\n" if opts.present?(:r)

        Clipboard.copy str

        unless opts.present?(:q)
          _pry_.output.puts text.green("-*-*- Copy history to clipboard -*-*-")
          _pry_.output.puts str
        end
      end
    end

    create_command "copy-result" do
      description "Copy result to clipboard."

      banner <<-BANNER
          Usage: copy-result [-q|--quiet]
      BANNER

      def options(opt)
        opt.on :q, :quiet, "quiet output", :optional => true
      end

      def process
        Clipboard.copy _pry_.last_result

        unless opts.present?(:q)
          _pry_.output.puts text.green("-*-*- Copy result to clipboard -*-*-")
          _pry_.output.puts _pry_.last_result
        end
      end
    end
  end
end

Pry.commands.import PryClipboard::Command

