def spawner(_name, _modelURI, _worldName, _x, _y, _z, _roll, _pitch, _yaw)
  <<-HEREDOC
  <plugin name=\"ignition::launch::GazeboFactory\"
          filename=\"libignition-launch-gazebo-factory.so\">
    <name>#{_name}</name>
    <allow_renaming>false</allow_renaming>
    <pose>#{_x} #{_y} #{_z + 0.15} #{_roll} #{_pitch} #{_yaw}</pose>
    <world>#{$worldName}</world>
    <is_performer>true</is_performer>
    <sdf version='1.6'>
      <include>
        <name>#{_name}</name>
        <uri>#{_modelURI}</uri>
        <!-- Diff drive -->
        <plugin filename=\"libignition-gazebo-diff-drive-system.so\"
                name=\"ignition::gazebo::systems::DiffDrive\">
          <left_joint>front_left_wheel_joint</left_joint>
          <left_joint>rear_left_wheel_joint</left_joint>
          <right_joint>front_right_wheel_joint</right_joint>
          <right_joint>rear_right_wheel_joint</right_joint>
          <wheel_separation>0.38</wheel_separation>
          <wheel_radius>0.1275</wheel_radius>
          <topic>/model/#{_name}/cmd_vel_relay</topic>
        </plugin>
        <!-- Publish robot state information -->
        <plugin filename=\"libignition-gazebo-pose-publisher-system.so\"
          name=\"ignition::gazebo::systems::PosePublisher\">
          <publish_link_pose>true</publish_link_pose>
          <publish_sensor_pose>true</publish_sensor_pose>
          <publish_collision_pose>false</publish_collision_pose>
          <publish_visual_pose>false</publish_visual_pose>
          <publish_nested_model_pose>#{$enableGroundTruth}</publish_nested_model_pose>
        </plugin>
        <!-- Battery plugin -->
        <plugin filename=\"libignition-gazebo-linearbatteryplugin-system.so\"
          name=\"ignition::gazebo::systems::LinearBatteryPlugin\">
          <battery_name>linear_battery</battery_name>
          <voltage>25.2</voltage>
          <open_circuit_voltage_constant_coef>25.2</open_circuit_voltage_constant_coef>
          <open_circuit_voltage_linear_coef>-7.2</open_circuit_voltage_linear_coef>
          <initial_charge>20</initial_charge>
          <capacity>20</capacity>
          <resistance>0.0052</resistance>
          <smooth_current_tau>5.0</smooth_current_tau>
          <power_load>10</power_load>
          <start_on_motion>true</start_on_motion>
        </plugin>
       <!-- Gas Sensor plugin -->"
       <plugin filename="libGasEmitterDetectorPlugin.so"
         name="subt::GasDetector">
         <topic>/model/#{_name}/gas_detected</topic>
         <update_rate>10</update_rate>
         <type>gas</type>
       </plugin>
        </include>
      </sdf>
    </plugin>
  HEREDOC
end

def rosExecutables(_name, _worldName)
  <<-HEREDOC
  <executable name='freyja_description'>
      <command>roslaunch --wait robotika_freyja_sensor_config_1 description.launch world_name:=#{$worldName} name:=#{_name}</command>
    </executable>
    <executable name='freyja_ros_ign_bridge'>
      <command>roslaunch --wait robotika_freyja_sensor_config_1 vehicle_topics.launch world_name:=#{$worldName} name:=#{_name}</command>
    </executable>
  HEREDOC
end
