class HighLine
  module Paginator

    #
    # Page print a series of at most _page_at_ lines for _output_.  After each
    # page is printed, HighLine will pause until the user presses enter/return
    # then display the next page of data.
    #
    # Note that the final page of _output_ is *not* printed, but returned
    # instead.  This is to support any special handling for the final sequence.
    #
    def page_print( output )
      lines = output.scan(/[^\n]*\n?/)
      while lines.size > highline.page_at
        highline_output.puts lines.slice!(0...highline.page_at).join
        highline_output.puts
        # Return last line if user wants to abort paging
        return (["...\n"] + lines.slice(-2,1)).join unless highline.send(:continue_paging?)
      end
      return lines.join
    end

    #
    # Ask user if they wish to continue paging output. Allows them to type "q" to
    # cancel the paging process.
    #
    def continue_paging?
      command = HighLine.new(@input, @output).ask(
        "-- press enter/return to continue or q to stop -- "
      ) { |q| q.character = true }
      command !~ /\A[qQ]\Z/  # Only continue paging if Q was not hit.
    end
  end
end