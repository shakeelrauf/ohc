# frozen_string_literal: true

class Import
  # Finds or creates an existing {Attendance} record based on the most recent {User::Child} from the CSV
  class FindOrCreateAttendance
    # @param user [User::Child] instance of the current CSV row
    # @param cabin [Cabin] instance of the cabin being uplodaded to
    def initialize(user, cabin)
      @user = user
      @cabin = cabin
    end

    # Finds, updates or creates the {Attendance} for the {User::Child} in the current {Camp}.
    def execute
      # is this child already in this cabin?
      if child_in_cabin?
        @cabin.attendances.find_by(user: @user)

      # Is this child in this camp, but not in this cabin?
      elsif child_in_camp?
        assign_child_to_cabin

      # Is this child not yet in this camp at all?
      else
        create_child_attendance
      end
    end

    private

    def child_in_cabin?
      @cabin.children.exists?(@user.id)
    end

    def child_in_camp?
      @cabin.camp.children.exists?(@user.id)
    end

    def assign_child_to_cabin
      attendance = @cabin.camp.attendances.find_by(user: @user)

      attendance.assign_attributes(cabin: @cabin)

      attendance_updater = Interactions::Attendances::Updating.new(attendance)
      attendance_updater.execute

      attendance
    end

    def create_child_attendance
      attendance = @user.attendances.build(camp: @cabin.camp, cabin: @cabin)

      attendance_creator = Interactions::Attendances::Creation.new(attendance)
      attendance_creator.execute

      attendance
    end
  end
end
