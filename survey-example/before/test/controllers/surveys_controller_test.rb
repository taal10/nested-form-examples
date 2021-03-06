require 'test_helper'

class SurveysControllerTest < ActionController::TestCase
  setup do
    @survey = surveys(:programming)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:surveys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey" do
    assert_difference('Survey.count') do
      post :create, survey: {
        name: "Programming languages",

        questions_attributes: {
          "0" => {
            content: "Which language allows closures?",

            answers_attributes: {
              "0" => { content: "Ruby Programming Language" },
              "1" => { content: "CSharp Programming Language" },
            }
          }
        }
      }
    end

    survey = assigns(:survey)

    assert survey.valid?
    survey.questions.each do |question|
      assert question.valid?
      assert question.persisted?

      question.answers.each do |answer|
        assert answer.valid?
        assert answer.persisted?
      end
    end
    assert_redirected_to survey_path(assigns(:survey))
    
    assert_equal "Programming languages", survey.name
    
    assert_equal "Which language allows closures?", survey.questions[0].content
    
    assert_equal "Ruby Programming Language", survey.questions[0].answers[0].content
    assert_equal "CSharp Programming Language", survey.questions[0].answers[1].content
    
    assert_equal "Survey: #{survey.name} was successfully created.", flash[:notice]
  end

  test "should not create survey with invalid params" do
    assert_difference('Survey.count', 0) do
      post :create, survey: {
        name: surveys(:programming).name,

        questions_attributes: {
          "0" => {
            content: nil,

            answers_attributes: {
              "0" => { content: "Ruby Programming Language" },
              "1" => { content: nil },
            }
          }
        }
      }
    end

    survey = assigns(:survey)

    assert_not survey.valid?
    assert_includes survey.errors.messages[:name], "has already been taken"
    assert_includes survey.questions[0].errors.messages[:content], "can't be blank"
    assert_includes survey.questions[0].answers[1].errors.messages[:content], "can't be blank"
  end

  test "should show survey" do
    get :show, id: @survey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey
    assert_response :success
  end

  test "should update survey" do
    assert_difference('Survey.count', 0) do
      patch :update, id: @survey, survey: {
        name: "Native languages",

        questions_attributes: {
          "0" => {
            content: "Which language is spoken in England?",
            id: questions(:one).id,

            answers_attributes: {
              "0" => { content: "The English Language", id: answers(:ruby).id },
              "1" => { content: "The Latin Language", id: answers(:cs).id },
            }
          },
        }
      }
    end

    survey = assigns(:survey)

    assert_redirected_to survey_path(survey)
    
    assert_equal "Native languages", survey.name
    
    assert_equal "Which language is spoken in England?", survey.questions[0].content
    
    assert_equal "The Latin Language", survey.questions[0].answers[0].content
    assert_equal "The English Language", survey.questions[0].answers[1].content
    
    assert_equal "Survey: #{survey.name} was successfully updated.", flash[:notice]
  end

  test "should destroy survey" do
    assert_difference('Survey.count', -1) do
      delete :destroy, id: @survey
    end

    assert_redirected_to surveys_path
  end
end
