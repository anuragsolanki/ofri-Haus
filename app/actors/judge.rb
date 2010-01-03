require File.dirname(__FILE__)+"/env"

module Actors
  # /actors/judge
  class Judge
    include Magent::Actor

    expose :on_question_solved
    def on_question_solved(payload)
      question_id, answer_id = payload
      question = Question.find(question_id)
      answer = Answer.find(answer_id)
      group = question.group

      if question.answer == answer && answer.user.answers.count == 1
        user_badges = answer.user.badges
        user_badges.find_by_token("troubleshooter") || user_badges.create!(:token => "troubleshooter", :type => "bronze", :group => group, :source => answer)
      end

      if question.answer == answer && answer.votes_average > 2
        user_badges = answer.user.badges
        user_badges.find_by_token("tutor") || user_badges.create!(:token => "tutor", :type => "bronze", :group => group, :source => answer)
      end
    end

    expose :on_question_unsolved
    def on_question_unsolved(payload)
      question_id, answer_id = payload
      question = Question.find(question_id)
      answer = Answer.find(answer_id)
      group = question.group

      if answer && question.answer.nil?
        user_badges = answer.user.badges
        badge = user_badges.find(:first, :token => "troubleshooter", :group_id => group.id, :source_id => answer.id)
        badge.destroy if badge
      end

      if answer && question.answer.nil?
        user_badges = answer.user.badges
        tutor = user_badges.find(:first, :token => "tutor", :group_id => group.id, :source_id => answer.id)
        tutor.destroy if tutor
      end
    end

    expose :on_ask_question
    def on_ask_question(payload)
      question = Question.find(payload.first)
      user = question.user

      if user.questions.count == 1
        user_badges = user.badges
        user_badges.find_by_token("inquirer") || user_badges.create!(:token => "inquirer", :type => "bronze", :group_id => group.id, :source => question)
      end
    end

    expose :on_destroy_question
    def on_destroy_question(payload)
      user = User.find(payload.first)
      if user.questions.first.nil?
        user_badges = user.badges
        inquirer = user_badges.find(:first, :token => "inquirer")
        inquirer.destroy if inquirer
      end
    end

    expose :on_vote
    def on_vote(payload)
      vote = Vote.find(payload.first)
      user = vote.user
      voteable = vote.voteable
      group = voteable.group

      if user.votes.count == 1 && vote.value == -1
        user_badges = user.badges
        user_badges.find_by_token("critic") || user_badges.create!(:token => "critic", :type => "bronze", :group_id => group.id, :source => vote)
      end

      # users
      if vuser = voteable.user
        user_badges = vuser.badges

        if vuser.votes_up >= 100
          user_badges.find_by_token("effort_medal") || user_badges.create!(:token => "effort_medal", :type => "silver", :group_id => group.id, :source => vote)
        end

        if vuser.votes_up >= 200
          user_badges.find_by_token("merit_medal") || user_badges.create!(:token => "merit_medal", :type => "silver", :group_id => group.id, :source => vote)
        end

        if vuser.votes_up >= 300
          user_badges.find_by_token("service_medal") || user_badges.create!(:token => "service_medal", :type => "silver", :group_id => group.id, :source => vote)
        end
      end

      # questions
      if voteable.kind_of?(Question) && vuser = voteable.user
        user_badges = vuser.badges

        if voteable.votes_average >= 10
          user_badges.find(:first, :token => "good_question", :source_id => voteable.id, :group_id => group.id) || user_badges.create!(:token => "good_question", :type => "silver", :group_id => group.id, :source => voteable)
        end
      end

      # answers
      if voteable.kind_of?(Answer) && vuser = voteable.user
        user_badges = vuser.badges

        if voteable.votes_average >= 10
          user_badges.find(:first, :token => "good_answer", :group_id => group.id, :source_id => voteable.id) || user_badges.create!(:token => "good_answer", :type => "silver", :group_id => group.id, :source => voteable)
        end
      end
    end
  end
  Magent.register(Judge.new)
end

if $0 == __FILE__
  Magent::Processor.new(Magent.current_actor).run!
end