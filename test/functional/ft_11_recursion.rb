
#
# Testing Ruote (OpenWFEru)
#
# Sat Jun 13 22:43:16 JST 2009
#

require File.dirname(__FILE__) + '/base'


class FtRecursionTest < Test::Unit::TestCase
  include FunctionalBase

  def test_main_recursion

    flunk
  end

  class CountingParticipant
    include Ruote::EngineContext
    include Ruote::LocalParticipant

    attr_reader :wfids

    def initialize (opts)

      @wfids = []
    end

    def consume (workitem)

      @wfids << workitem.fei.wfid

      workitem.fields['count'] ||= 0
      workitem.fields['count'] = workitem.fields['count'] + 1

      @context[:s_tracer] << workitem.fields['count'].to_s + "\n"

      if workitem.fields['count'] > 5
        engine.cancel(workitem.fei.parent_wfid)
      else
        reply_to_engine(workitem)
      end
    end

    def cancel (fei)
    end
  end

  def test_sub_recursion

    pdef = Ruote.process_definition do
      define 'sub0' do
        sequence do
          alpha
          sub0
        end
      end
      sub0
    end

    wfids = []

    alpha = @engine.register_participant :alpha, CountingParticipant

    #noisy

    assert_trace(pdef, %w[ 1 2 3 4 5 6 ], :ignore_remaining_expressions => true)

    alpha.wfids.each_with_index { |wfid, i| assert_match /.*\_#{i}$/, wfid }
  end
end

