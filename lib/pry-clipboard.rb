
require 'pry'
require 'clipboard'
require "pry-clipboard/version"

module PryClipboard
  Command = Pry::CommandSet.new do
    create_command "paste" do
      description "Paste from clipboard"

      banner <<-BANNER
        Usage: paste [-q|--quiet]
      BANNER

      def options(opt)
        opt.on :q, :quiet, "quiet output", :optional => true
      end

      def process
        str = Clipboard.paste
        unless opts.present?(:q)
          _pry_.output.puts text.green("-*-*- Paste from clipboard -*-*-")
          _pry_.output.puts str
        end
        eval_string << str
      end
    end

    create_command "copy-history" do
      description "Copy history to clipboard"

      banner <<-BANNER
          Usage: copy-history [N] [-T|--tail N] [-H|--head N] [-R|--range N..M]  [-G|--grep match] [-l] [-q|--quiet]

          e.g: `copy-history`
          e.g: `copy-history -l`
          e.g: `copy-history 10`
          e.g: `copy-history -H 10`
          e.g: `copy-history -T 5`
          e.g: `copy-history -R 5..10`
      BANNER

      def options(opt)
        opt.on :l, "Copy history with last result", :optional => true
        opt.on :H, :head, "Copy the first N items.", :optional => true, :as => Integer
        opt.on :T, :tail, "Copy the last N items.", :optional => true, :as => Integer
        opt.on :R, :range, "Copy the given range of lines.", :optional => true, :as => Range
        opt.on :G, :grep, "Copy lines matching the given pattern.", :optional => true, :as => String
        opt.on :q, :quiet, "quiet output", :optional => true
      end

      def process
        history = Pry::Code(Pry.history.to_a)

        history = if num_arg
          history.take_lines(num_arg, 1)
        else
          history = history.grep(opts[:grep]) if opts.present?(:grep)
          case
          when opts.present?(:range)
            history.between(opts[:range])
          when opts.present?(:head)
            history.take_lines(1, opts[:head] || 10)
          when opts.present?(:tail) || opts.present?(:grep)
            n = opts[:tail] || 10
            n = history.lines.count if n > history.lines.count
            history.take_lines(-n, n)
          else
            history.take_lines(-1, 1)
          end
        end

        str = history.raw
        str += "#=> #{_pry_.last_result}\n" if opts.present?(:l)
        Clipboard.copy str

        unless opts.present?(:q)
          _pry_.output.puts text.green("-*-*- Copy history to clipboard -*-*-")
          _pry_.output.puts str
        end
      end

      def num_arg
        first = args[0]
        if first && first.to_i.to_s == first
          first.to_i
        else
          nil
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

