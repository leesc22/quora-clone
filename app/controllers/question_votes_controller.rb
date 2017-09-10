require 'byebug'

post '/question_votes' do
	# puts params
	# {"question_vote"=>{"vote"=>"1", "user_id"=>"1", "question_id"=>"2"}, "captures"=>[]}
	# {"question_vote"=>{"vote"=>"-1", "user_id"=>"1", "question_id"=>"2"}, "captures"=>[]}

	@user_id = params[:question_vote][:user_id].to_i
	@question_id = params[:question_vote][:question_id].to_i
	user_voted = QuestionVote.find_by(user_id: @user_id, question_id: @question_id)

	unless user_voted
		question_votes = QuestionVote.new(params[:question_vote])
	else
		question_votes = user_voted
		param_vote = params[:question_vote][:vote].to_i
		unless question_votes.vote == param_vote
			question_votes.vote += param_vote
		end
	end

	if question_votes.save
		redirect back
	else
		@question_votes_errors = question_votes.errors.messages
		# @user = User.all
		# @questions = Question.all
		# @answers = Answer.all
		# @question_votes = QuestionVote.all
		# erb :"static/index"

		@question = Question.find_by_id(@question_id)
		@title = @question.title + " - Quora Clone"
		@answers = Answer.where(question_id: @question.id).order(created_at: :desc)
		@user = User.all
		@question_votes = QuestionVote.where(question_id: @question.id).sum(:vote)
		erb :"static/question"	
	end
end