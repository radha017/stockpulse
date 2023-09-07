require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "pending_email" do
    mail = UserMailer.pending_email
    assert_equal "Pending email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "approved_email" do
    mail = UserMailer.approved_email
    assert_equal "Approved email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
