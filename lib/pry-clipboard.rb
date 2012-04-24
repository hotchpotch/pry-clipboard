
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
          e.g: `copy-history -l`
          e.g: `copy-history -H 10`
          e.g: `copy-history -T 5`
          e.g: `copy-history -r 5..10`
      BANNER

      def options(opt)
        opt.on :l, "Copy history with last result", :optional => true
        opt.on :H, :head, "Copy the first N items.", :optional => true, :as => Integer
        opt.on :T, :tail, "Copy the last N items.", :optional => true, :as => Integer
        opt.on :r, :range, "Copy the given range of lines.", :optional => true, :as => Range
        opt.on :q, :quiet, "quiet output", :optional => true
      end

      def process
        history = Pry::Code(Pry.history.to_a)
        history = case
        when opts.present?(:head)
          history.take_lines(1, opts[:head] || 10)
        when opts.present?(:tail)
          history.take_lines(-(opts[:tail] || 10), opts[:tail] || 10)
        when opts.present?(:range)
          history.between(opts[:range])
        else
          history.take_lines(-1, 1)
        end

        str = history.raw
        str += "#=> #{_pry_.last_result}\n" if opts.present?(:l)
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
        res = "#{_pry_.last_result}\n"
        Clipboard.copy res

        unless opts.present?(:q)
          _pry_.output.puts text.green("-*-*- Copy result to clipboard -*-*-")
          _pry_.output.print res
        end
      end
    end
  end
end

Pry.commands.import PryClipboard::Command

