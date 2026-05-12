pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            // Ensure the container has permissions to the workspace
            args '-u root'
        }
    }

	stages {
		stage('Initialize') {
			steps {
				sh 'arm-none-eabi-gcc --version'
			}
		}

		stage('Build') {
			steps {
				sh 'bear -- make -j$(nproc)'
			}
		}
		stage('Flash and Test') {
			agent {
				label 'stm32-hw-node'
			}
			steps {
				script {
					// Re-use the docker run logic with hardware passthrough
					sh '''
					docker run --rm --privileged \
						-v /dev/bus/usb:/dev/bus/usb \
						-v $(pwd):/home/dev/project \
						stm32-dev-env make flash
					'''
				}
			}
		}
		stage('Static Analysis') {
			steps {
				// Optional: Run cppcheck or other tools installed in the Dockerfile
				sh 'cppcheck --enable=all --inconclusive --std=c99 src/'
			}
		}
    }

    post {
        success {
            // Archive the resulting binaries for download
            archiveArtifacts artifacts: 'build/*.bin, build/*.elf, build/*.hex', fingerprint: true
        }
    }
}
