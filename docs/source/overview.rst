.. _overview:

Modbus Smart Energy Meter
=========================

Project Overview
----------------

This project provides a robust and efficient **Modbus Smart Energy Meter** designed for **Industrial IoT (IIoT) gateways**. Its primary objective is to enable seamless communication between **Modbus-based energy meters** (typically using the Modbus RTU protocol over serial interfaces such as RS485) and **cloud platforms** or **local monitoring systems** via **MQTT**.

The plugin serves as a middleware layer, bridging industrial field devices with modern IoT communication protocols. It enables real-time energy data collection, monitoring, and remote analytics.

.. image:: _static/tedge_EM_BD.jpeg
   :alt: Project Block Diagram
   :align: center
   :width: 1500px
   :height: 700px

**Key Features**

- **Modbus RTU Support**: Communicates with Modbus RTU meters over serial interfaces.
- **MQTT Integration**: Publishes data to MQTT brokers such as Mosquitto or AWS IoT.
- **Flexible Configuration**: Supports configurable register maps, baud rates, and topics.
- **Data Transformation**: Converts Modbus registers into human-readable values.
- **Cloud and Edge Compatibility**: Works with both local and cloud monitoring systems.
- **Logging and Debugging**: Includes built-in logging for diagnostics and development.

**How It Works**

1. **Serial Communication Initialization**  
   Establishes a connection to Modbus devices via serial ports (e.g., RS485).

2. **Data Acquisition**  
   Sends Modbus queries to read energy-related registers, including:
   
   - Voltage (V)
   - Current (A)
   - Power (kW/kWh)
   - Power Factor
   - Frequency (Hz)
   - Active Power (W)
   - Apparent Power (VA)

3. **Data Processing**  
   Parses and scales raw register values based on the meter’s specification.

4. **MQTT Publishing**  
   Sends processed data to an MQTT broker under structured topics:

   ::

      /energy/<device_id>/voltage
      /energy/<device_id>/power

5. **Monitoring & Analytics**  
   MQTT messages are consumed by cloud or local systems for display, storage, or analysis.


Project Architecture
--------------------
This section provides an overview of the architecture of the Modbus Smart Energy Meter, illustrating how it integrates with Modbus devices and MQTT brokers.
The architecture consists of several key components that work together to enable efficient data collection and transmission:

.. image:: _static/project_arch.png
   :alt: Project architecture image
   :align: center
   :width: 1500px

.. raw:: html

   <br><br><br>


Technical Stack
---------------

+-------------------+------------------------------------------+
| Component         | Technology Used                          |
+===================+==========================================+
| Programming Lang  | Python / Rust / C++                      |
+-------------------+------------------------------------------+
| Communication     | Modbus RTU over RS485 serial             |
+-------------------+------------------------------------------+
| Messaging         | MQTT                                     |
+-------------------+------------------------------------------+
| Config Format     | JSON / YAML / TOML                       |
+-------------------+------------------------------------------+
| Logging           | Syslog / File-based                      |
+-------------------+------------------------------------------+
| Deployment        | systemd service / Docker container       |
+-------------------+------------------------------------------+
| OS Compatibility  | Debian / Ubuntu / OpenWRT                |
+-------------------+------------------------------------------+

**Security Considerations**

- TLS/SSL encryption for MQTT
- MQTT authentication (username/password or certificates)
- Serial access controlled by system permissions

**Use Cases**

- Real-time monitoring in industrial settings
- Integration with cloud energy platforms
- Energy logging for audit or compliance
- Anomaly detection and optimization

**Testing & Validation**

- **Simulators**: ModRSsim2, ModbusPal
- **Hardware**: Tested with Schneider, Secure, Selec, etc.
- **Tools**: MQTT.fx, Mosquitto CLI for MQTT debugging

**Future Enhancements**

- Modbus TCP support
- Device auto-discovery
- OTA update integration
- OPC-UA or REST API bridge
- Web-based configuration UI 

.. _device_connection:
   
Device connection
-----------------
This section describes how the PHYTedge Modbus Plugin connects to energy meters and other devices using Modbus RTU over RS485, and how it integrates with MQTT for data transmission.
The plugin establishes a serial connection to the Modbus devices, reads energy-related registers, processes the data, and publishes it to an MQTT broker for further consumption.

.. note::

   Currently, we are not able to connect the Panel energy meter directly to the Tauri-L using RS485.  
   Therefore, we have used an RS485 to TTL converter, and connected the TTL output to the USB port of the Tauri-L.


.. image:: _static/Connection.jpeg
   :alt: Project architecture image
   :align: center
   :width: 1500px


.. raw:: html

   <br><br><br>   


Source Code Brief
-----------------

The following table summarizes the key components of the source code:

+--------------------------+------------------------------------------------------------+
| File/Directory           | Description                                                |
+==========================+============================================================+
| Modbus_plugin/           | Contains `app.py` which manages register mapping and       |
|                          | publishes data (measurements, alarms, events) to cloud.    |
+--------------------------+------------------------------------------------------------+
| Docker-compose.yml       | Defines how to launch services using Docker Compose.       |
+--------------------------+------------------------------------------------------------+
| Dockerfile               | Instructions to build the Docker image.                    |
+--------------------------+------------------------------------------------------------+
| main.py                  | Entry point of the application that starts the plugin.     |
+--------------------------+------------------------------------------------------------+
| modbus_plugin.service    | (Optional) `systemd` file to run app as background service.|
+--------------------------+------------------------------------------------------------+
| requirements.txt         | Lists Python dependencies for the application.             |
+--------------------------+------------------------------------------------------------+
| docker_install.sh        | Docker installation script on the device.                  |
+--------------------------+------------------------------------------------------------+
| tedge_install.sh         | Thin-Edge installation script on the device.               |
+--------------------------+------------------------------------------------------------+

Getting started with Thin-edge
------------------------------

This section describes how to run the PHYTEC Edge Modbus Python application
and connect it to ThingsBoard using Thin-edge on the i.MX8MM Tauri-L platform.

**Prerequisites**

Ensure the following before running the application:

* Thin-edge is properly installed and configured.
* Device certificates are provisioned.
* Network connectivity is available.
* Python3 runtime and required dependencies are installed.

**Application Location**

The Python application source is installed under:

::

   /usr/share/phytedge-modbus/

To verify the installation, execute:

::

   root@phygate-tauri-l-imx8mm-2:~# cd /usr/share/
   root@phygate-tauri-l-imx8mm-2:share# ls

You should see the directory:

::

   phytedge-modbus/

Navigate into the application directory:

::

   root@phygate-tauri-l-imx8mm-2:share# cd phytedge-modbus/
   root@phygate-tauri-l-imx8mm-2:phytedge-modbus# ls

The directory contains the following files:

::

   modbus_plugin/
   Dockerfile
   docker-compose.yml
   entrypoint.sh
   main.py
   requirements.txt
   tests/
   README.md
   docker_install.sh
   log.txt
   modbus_plugin.service
   tedge_install.sh

**Running the Application**

To start the Python application manually, execute:

::

   root@phygate-tauri-l-imx8mm-2:phytedge-modbus# python3 main.py

The application will initialize the Modbus plugin and establish
communication with ThingsBoard through Thin-edge.

Logs:

::

   root@phygate-tauri-l-imx8mm-2:phytedge-modbus# ls
   modbus_plugin/  Dockerfile  docker-compose.yml  entrypoint.sh  main.py                requirements.txt
   tests/          README.md   docker_install.sh   log.txt        modbus_plugin.service  tedge_install.sh
   root@phygate-tauri-l-imx8mm-2:phytedge-modbus# python3 main.py 
   Connected to Modbus device SDM230. Press Ctrl+C to stop.
   Event Sent: Device is online
   Sent Voltage: 228.348
   Sent Current: 0.000
   Sent Frequency: 50.000
   Sent Active Power: 0.000
   Sent Apparent Power: 0.000
   Sent Power Factor: 1.000
   Sent Energy: 0.002
   Sent Voltage: 228.124
   Sent Current: 0.000

.. _energy meter device selection:

Energy Meter Device Selection
-----------------------------

Right now we are using the Selec MFM3833A energy meter and SDM230-MODBUS-MID V2 energy meter, which is a Modbus RTU device. The device is connected to the Tauri-L gateway via RS485.

The Selec MFM3833A energy meter and SDM230-MODBUS-MID V2 energy meter follows different Modbus registers for reading the energy meter data.


The following table summarizes the Modbus registers for both devices:

.. list-table::
   :header-rows: 1

   * - Register
     - Selec MFM3833A
     - Byte Format (MFM3833A)
     - SDM230-MODBUS-MID V2
     - Byte Format (SDM230)
   * - Voltage
     - 8
     - MSB
     - 0
     - MSB
   * - Current
     - 15
     - LSB
     - 6
     - MSB
   * - Frequency
     - 55
     - LSB
     - 70
     - MSB
   * - Active Power
     - 23
     - LSB
     - 12
     - MSB
   * - Apparent Power
     - 29
     - LSB
     - 18
     - MSB
   * - Power Factor
     - 47
     - LSB
     - 30
     - MSB
   * - Energy
     - 57
     - LSB
     - 342
     - MSB

The following table lists the measurement topics for Cumulocity, AWS, and Thingsboard:

.. list-table::
   :header-rows: 1

   * - Platform
     - Measurement Topic
   * - Cumulocity
     - te/device/main///m/environment
   * - AWS
     - aws/td/SelecMFM383A
   * - Thingsboard
     - v1/devices/me/SEMtelemetry


The code changes as follows:

   a. Change the **DEVICE_CONFIG** variable to match your energy meter device.

   b. Parameters like **name**, **port**, **baudrate**, **measurement_topic**, **address** and **byte_order** should be set according to your device specifications.

    .. image:: _static/code-changes-main.png
       :alt: AWS IoT Core Subscribe to Topic
       :align: center
       :width: 1000px

    .. raw:: html

        <br>        


Connecting to Cumulocity
------------------------

1. Start your free trial `here <https://www.cumulocity.com/start-your-journey/free-trial/>`_.

.. raw:: html

   <br>

2. Register and create a tenant account.

.. image:: _static/reg_user.png
   :alt: Cumulocity Registration
   :align: center
   :width: 1000px

.. raw:: html

   <br>

3. You will receive an email containing your tenant name and a one-time credential.

.. raw:: html

   <br>

4. Click on **Login** in the email you received and enter the credentials provided.

.. image:: _static/otp_instance.png
   :alt: Cumulocity OTP Instance
   :align: center
   :width: 1000px

.. raw:: html

   <br>

5. After logging in with your username and one-time password, you will be prompted to set a permanent password.

.. image:: _static/permanent_pass.png
   :alt: Cumulocity Permanent Password
   :align: center
   :width: 1000px


.. raw:: html

   <br>

6. After setting your permanent password, you will be asked to log in again with your username and the new password. You will then be redirected to the Cumulocity dashboard.

.. image:: _static/cumulocity_dashboard.png
   :alt: Cumulocity Dashboard
   :align: center
   :width: 1000px


.. raw:: html

   <br>

.. note::

   **Pre-requisite**: You need to have the Cumulocity CLI installed on your local system (TAURI-L) to connect to the Cumulocity tenant. 
   You can get the **Cumulocity IoT URL** and **Cumulocity IoT User** from the Cumulocity dashboard.

   - **Device ID** (Your preferred device ID name)
   - **Cumulocity IoT URL** (e.g., example.eu-latest.com)
   - **Cumulocity IoT User** (Your username for the Cumulocity tenant)


.. raw:: html

   <br>


7. Open the TAURI-L terminal and execute the following commands to install the Cumulocity CLI.


   a. Set the URL of your Cumulocity tenant.

   .. image:: _static/c8y_url_selection.png
      :alt: AWS IoT Core MQTT Test Client
      :align: center
      :width: 1000px

   .. raw:: html

      <br>

   .. image:: _static/c8y_url.png
      :alt: AWS IoT Core MQTT Test Client
      :align: center
      :width: 1000px

   .. raw:: html

      <br>

   .. code-block:: shell

      sudo tedge config set c8y.url <replace with your tenantDomainName>

   b. Set the path to the root certificate if necessary. The default is /etc/ssl/certs.

   .. code-block:: shell

      sudo tedge config set c8y.root_cert_path /etc/ssl/certs/ca-certificates.crt

   c. Create certificate and key files for the Cumulocity tenant.

   .. code-block:: shell

      sudo tedge cert remove
      sudo tedge cert create --device-id "your device ID"

   d. Upload the certificate to Cumulocity.

   .. code-block:: shell

      sudo tedge cert upload c8y --user "your username" --password "your password"

   e. Finally, run the following command to connect to Cumulocity.

   .. note::

      If you have tried to connect your device to the Thingsboard, before trying to connect with AWS, you have to follow the below commands, to unset Thingsboard.

      .. code-block:: shell

         sudo tedge config set mqtt.client.host localhost
         sudo tedge config set mqtt.port 8883
         sudo tedge config unset mqtt.client.auth.cafile
         sudo tedge config unset mqtt.client.auth.certfile
         sudo tedge config unset mqtt.client.auth.keyfile

   .. code-block:: shell

      sudo tedge connect c8y

.. raw:: html

   <br>


8. After registering your device with Cumulocity, navigate to the Cumulocity dashboard and click on **Application switcher** in the top right corner.

   .. image:: _static/app_switch.png
      :alt: Cumulocity Application Switcher
      :align: center
      :width: 1000px


.. raw:: html

   <br>

9. Select **Device Management** from the dropdown menu to be redirected to the Device Management dashboard.

   .. image:: _static/device_management.png
      :alt: Cumulocity Device Management
      :align: center
      :width: 1000px


.. raw:: html

   <br>

10. In the Device Management dashboard, click on **All devices** to view your registered device.

   .. image:: _static/reg_device.png
      :alt: Cumulocity All Devices
      :align: center
      :width: 1000px

.. raw:: html

   <br>


11. Refer to :ref:`Device connection <device_connection>` for instructions on making the physical connection of the Selec MFM383A Panel Energy Meter to the Tedge device (TAURI-L) using an RS485 to USB converter.

.. raw:: html

   <br>


12. Execute the source code on the device to start sending meter data to Cumulocity.

   .. note::

    For Cumulocity cloud open the path of the project **PHYTedge-Modbus-Plugin/modbus_plugin/app.py**
    and change the **port** to 'your_device_port' and configuration **DEVICE_CONFIG**
    and change the 'measurement_topic' to:
    **te/device/main///m/environment** 

    For Energy meter selection please refer to :ref:`Energy Meter Device Selection <energy meter device selection>`.

.. raw:: html

   <br>


13. After running the source code, you will be able to see the Energy Meter data in the Cumulocity Device ID.

    a. Click on the device ID to be redirected to your device ID dashboard.

   .. image:: _static/device_dashboard.png
      :alt: Cumulocity Device ID Dashboard
      :align: center
      :width: 1000px

   .. raw:: html

      <br>

    b. Click on **Measurements** in the left sidebar to view the energy meter data.

   **Voltage**

   .. image:: _static/voltage.png
      :alt: Cumulocity Measurements
      :align: center
      :width: 1000px

   **Current**

   .. image:: _static/current.png
      :alt: Cumulocity Current
      :align: center
      :width: 1000px

   **Energy**

   .. image:: _static/energy.png
      :alt: Cumulocity Energy
      :align: center
      :width: 1000px

   **Frequency**

   .. image:: _static/frequency.png
      :alt: Cumulocity Frequency
      :align: center
      :width: 1000px

   **Power Factor**

   .. image:: _static/pf.png
      :alt: Cumulocity Power Factor
      :align: center
      :width: 1000px

   **Apparent Power**

   .. image:: _static/ap.png
      :alt: Cumulocity Apparent Power
      :align: center
      :width: 1000px

   **Active Power**

   .. image:: _static/activeP.png
      :alt: Cumulocity Active Power
      :align: center
      :width: 1000px

.. raw:: html

   <br><br><br>         

Connecting to AWS
-----------------

1. Create an AWS account if you don't have one already by visiting `AWS Free Tier <https://aws.amazon.com/free/>`_.

2. After creating your account, log in to the AWS Management Console.

3. Navigate to the search bar and type IoT Core.


.. image:: _static/aws_iot_core.png
   :alt: AWS IoT Core
   :align: center
   :width: 1000px


.. raw:: html

   <br>

4. Get the aws IoT core URL to set in the Thin-edge configuration.

5. Click on **View domain configuration**


.. image:: _static/aws-domain.png
   :alt: AWS IoT Core Settings
   :align: center
   :width: 1000px


.. raw:: html

   <br>


.. image:: _static/aws-domain-name.png
   :alt: AWS IoT Core Settings
   :align: center
   :width: 1000px


.. raw:: html

   <br>


6.  Open the TAURI-L terminal and execute the following commands to install the AWS CLI.


    .. note::

       The **Device ID** can be chosen by the user; however, it must remain consistent across all communications and operations to ensure proper identification and tracking.

    a. Set the URL of your AWS IoT Core.    


    .. code-block:: shell

       tedge config set aws.url "your-aws-iot Domain Name"

    b. Create certificate and key files for AWS IoT Core. 


    .. code-block:: shell

       sudo tedge cert remove
       sudo tedge cert create --device-id "your device ID"

7. Navigate to the **Security** section in the AWS IoT Core console sidebar and click on **Policies** and click on **Create policy**.


    .. image:: _static/create-policy.png
       :alt: AWS IoT Core Policies
       :align: center
       :width: 1000px


.. raw:: html

   <br>


8. Click on **json** and paste the below policy and then click on **create**.


    .. image:: _static/json-policy.png
       :alt: AWS IoT Core Json Policies
       :align: center
       :width: 1000px


.. raw:: html

   <br>


.. code-block:: json

   {
       "Version": "2012-10-17",
       "Statement": [
           {
           "Effect": "Allow",
           "Action": "iot:Connect",
           "Resource": "arn:aws:iot:ap-southeast-2:825010217716:client/${iot:Connection.Thing.ThingName}"
           },
           {
           "Effect": "Allow",
           "Action": "iot:Subscribe",
           "Resource": [
               "arn:aws:iot:ap-southeast-2:825010217716:topicfilter/thinedge/${iot:Connection.Thing.ThingName}/cmd/#",
               "arn:aws:iot:ap-southeast-2:825010217716:topicfilter/$aws/things/${iot:Connection.Thing.ThingName}/shadow/#",
               "arn:aws:iot:ap-southeast-2:825010217716:topicfilter/thinedge/devices/${iot:Connection.Thing.ThingName}/test-connection"
           ]
           },
           {
           "Effect": "Allow",
           "Action": "iot:Receive",
           "Resource": [
               "arn:aws:iot:ap-southeast-2:825010217716:topic/thinedge/${iot:Connection.Thing.ThingName}/cmd",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/thinedge/${iot:Connection.Thing.ThingName}/cmd/*",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/$aws/things/${iot:Connection.Thing.ThingName}/shadow",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/$aws/things/${iot:Connection.Thing.ThingName}/shadow/*",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/thinedge/devices/${iot:Connection.Thing.ThingName}/test-connection"
           ]
           },
           {
           "Effect": "Allow",
           "Action": "iot:Publish",
           "Resource": [
               "arn:aws:iot:ap-southeast-2:825010217716:topic/thinedge/${iot:Connection.Thing.ThingName}/td",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/thinedge/${iot:Connection.Thing.ThingName}/td/*",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/$aws/things/${iot:Connection.Thing.ThingName}/shadow",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/$aws/things/${iot:Connection.Thing.ThingName}/shadow/*",
               "arn:aws:iot:ap-southeast-2:825010217716:topic/thinedge/devices/${iot:Connection.Thing.ThingName}/test-connection"
           ]
           }
       ]
   }

9. Register a Device (thing)

    a. Navigate to the **Manage** section in the AWS IoT Core console sidebar.

    b. Click on **All devices** and select **Things**.


    .. image:: _static/aws-create-thing.png
       :alt: AWS IoT Core Create Thing
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

    c. Click on **Create things** and then select **Create single thing** and then click **Next**.


    .. image:: _static/create-thing.png
       :alt: AWS IoT Core Thing Create
       :align: center
       :width: 1000px


    .. raw:: html

       <br>
    


    .. image:: _static/single-thing.png
       :alt: AWS IoT Core Single Thing Create
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

    d. Enter the device name (your device ID), select **Unnamed shadow (classic)** and click on **Next**.


    .. image:: _static/create-device.png
       :alt: AWS IoT Core Device Name
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

    e.  On the device certificate page, choose **Use my certificate → CA is not registered with AWS IoT**

    f. Click on **Choose file** under **Certificate** and select your **tedge-certificate.pem** file, and then click on **Open → Next**.


    .. image:: _static/device-cert.png
       :alt: AWS IoT Core Device Name
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

    g. Select the policy you created earlier and click on **Create thing**.


    .. image:: _static/thing-policy.png
       :alt: AWS IoT Core Thing Policy
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

10. Head over to your TAURI-L terminal and connect your device to AWS IoT Core by running the following command:


    .. note::

       If you have tried to connect your device to the Thingsboard, before trying to connecting with AWS, you have to follow the below commands, to unset Thingsboard.

       .. code-block:: shell

          sudo tedge config set mqtt.client.host localhost
          sudo tedge config set mqtt.port 8883
          sudo tedge config unset mqtt.client.auth.cafile
          sudo tedge config unset mqtt.client.auth.certfile
          sudo tedge config unset mqtt.client.auth.keyfile


    .. code-block:: shell

       sudo tedge connect aws


11. Go to the AWS IoT core and select your thing and click on **Activity** and then click on **MQTT test client**.


    .. image:: _static/connect_client.png
       :alt: AWS IoT Core MQTT Test Client
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

12. Click on **Topic Filter** and enter the topic **thinedge/<your-device-id>/#** and click on **Subscribe to topic**.


    .. image:: _static/aws-subscribe.png
       :alt: AWS IoT Core Subscribe to Topic
       :align: center
       :width: 1000px


    .. raw:: html

       <br>

13. Execute the source code on the device to start sending meter data to AWS.


.. note::

   For AWS cloud open the path of the project **PHYTedge-Modbus-Plugin/modbus_plugin/app.py**
   and change the **port** to 'your_device_port' and configuration **DEVICE_CONFIG**
   and change the 'measurement_topic' to:
   **aws/td/<Use your prefered topic>**

   For Energy meter selection please refer to :ref:`Energy Meter Device Selection <energy meter device selection>`.

   - And then execute the source code on the device.

   .. raw:: html

      <br>

   .. image:: _static/code-change.png
      :alt: Software Code Change for AWS
      :align: center
      :width: 1500px

   .. raw:: html

      <br>

14. Head over to the AWS IoT Core MQTT test client and you should see the data being published to the topic **aws/td/#**.


    .. image:: _static/aws-output.png
       :alt: AWS IoT Core Data
       :align: center
       :width: 1000px

    .. raw:: html

       <br>   


Connecting to Thingsboard
-------------------------

1. Head over to the TAURI-L terminal and execute the following commands to install the Thingsboard CLI.


    a. Copy the ca.pem and ca_key.pem of the server to the client device.

    .. note::

       ca certificates will only be provided by the PHYTEC India Thingsboard server admin.

    b. Create a csr file for the client device


    .. code-block:: shell

       sudo tedge cert remove
       sudo tedge cert create-csr --device-id "Tauri-L_GW"

    c. Sign the certificate with the csr file


    .. code-block:: shell

       sudo openssl x509 -req -in tedge.csr -CA ca.pem -CAkey ca_key.pem   -CAcreateserial -out tedge-certificate.pem -days 365 -sha256

    d. Set the Thingsboard URL.


    .. code-block:: shell

       sudo tedge config set mqtt.client.host 108.181.190.31
       sudo tedge config set mqtt.port 8883
       sudo tedge config set mqtt.client.auth.cafile <ca file path>
       sudo tedge config set mqtt.client.auth.certfile <cert file path>
       sudo tedge config set mqtt.client.auth.keyfile <key file path>

2. You can access thingsboard by visiting `Thingsboard <http://108.181.190.31:8080/>`_.

3. For username use: **..** and for password use: **..** and click on **Sign In**.

.. note::

   The username and password are provided by the PHYTEC India Thingsboard server admin.

4. After signing in, you will be redirected to the Thingsboard dashboard.


.. image:: _static/tb_dashboard.png
   :alt: TB Dashboard
   :align: center
   :width: 1000px


.. raw:: html

   <br>

5. Click on **Profiles** in the left sidebar and then click on **Device profiles**.

6. Click on **+** and select **Create new device profile**.


.. image:: _static/tb_add_profile.png
   :alt: TB add profile
   :align: center
   :width: 1000px


.. raw:: html

   <br>

7. Fill the name as **Tauri-L_GW**, and in the default rule chain select **Root Rule Chain**. Then click on **Transport configuration** and select Transport type as **MQTT**.


.. image:: _static/tb_device_profile.png
   :alt: TB Device Profile
   :align: center
   :width: 1000px


.. raw:: html

   <br>


.. note::

   For the **MQTT device topic filter** select the **Telemetry topic filter** and change it to: **v1/devices/me/SEMtelemetry**.


.. image:: _static/tb_transport_profile.png
   :alt: TB Transport Profile
   :align: center
   :width: 1000px


.. raw:: html

   <br>

8. Click on **Devices** in the left sidebar and then click on **+** to add a new device.


.. image:: _static/tb_device.png
   :alt: TB Device
   :align: center
   :width: 1000px


.. raw:: html

   <br>

9. Fill the name as **Tauri-L_GW** and select the device profile created in step 6. Then click on **Next: Credentials**.


.. image:: _static/tb_device_creation.png
   :alt: TB Device Creation
   :align: center
   :width: 1000px


.. raw:: html

   <br>

10. In the credentials section, select **X.509** and paste your **tedge-certificate.pem** and click on **Add**.


    .. note::

       You can use cat command on your client device terminal and paste the certificate in the credentials section. Make sure you paste the certificate in the correct format.

       Paste your certificate in the following format (row-wise, as shown):

       ::

          -----BEGIN CERTIFICATE-----
          MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAn...
          ...
          ...
          ...
          -----END CERTIFICATE-----



.. image:: _static/tb_device_credentials.png
   :alt: TB Device Credentials
   :align: center
   :width: 1000px


.. raw:: html

   <br>

11. Now your device creation is ready to recieve data from the client device.

12. Head over to the Tauri-L terminal and execute the source code on the device to start sending meter data to Thingsboard.


.. note::

   For Thingsboard cloud open the path of the project **PHYTedge-Modbus-Plugin/modbus_plugin/app.py**
   and change the **port** to 'your_device_port' and configuration **DEVICE_CONFIG**
   and change the 'measurement_topic' to:
   **v1/devices/me/SEMtelemetry** 

   For Energy meter selection please refer to :ref:`Energy Meter Device Selection <energy meter device selection>`.


.. image:: _static/tb_code_change.png
   :alt: Software Code Change for Thingsboard
   :align: center
   :width: 1000px


.. raw:: html

   <br>

13. Now after execution of the source code, you will be able to see the Energy Meter data in the Thingsboard Device **Latest Telemetry** section.


    .. image:: _static/tb_device_output.png
       :alt: TB Device ID Dashboard
       :align: center
       :width: 1000px

    .. raw:: html

       <br>

               
