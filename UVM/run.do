vlib work
vlog -f file.txt +define+SIM -cover bcesft
vsim -voptargs=+acc work.Top -cover
# add wave * 
coverage save TOP.ucdb -onexit
run -all
coverage report -output Scov_report.txt -detail -codeAll
coverage report -detail -cvg -directive -comments -output fcover_report.txt {}
vcover report -html -details -assert -directive -codeAll -output coverage_report.html TOP.ucdb