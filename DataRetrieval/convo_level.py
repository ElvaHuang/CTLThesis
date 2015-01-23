#!/usr/bin/python

import MySQLdb
import MySQLdb.cursors
import csv
import re

# Open database connection
db = MySQLdb.connect('192.168.6.2', 'elva', '1207hry0111Njy', 'ctl', cursorclass=MySQLdb.cursors.Cursor)

# Create a cursor
cursor = db.cursor()

values = {
       2: 'Q2_conv_type',
       8: 'Q8_conv_resolution',
       13: 'Q13_issues',
       79: 'Q79_main_issue',
       15: 'Q15_presenting_issue',
       67: 'Q67_suicidal_capability',
       66: 'Q66_suicidal_intent',
       75: 'Q75_active_rescue',
       78: 'Q78_desire_notes',
       36: 'Q36_visitor_feeling'
}



for n in values:
       values[str(n)] = values.pop(n)

# Here's the SQL statement
sql = """select
               c.id as conv_id,
               ta.id as texter_id,
               a.id as counselor_id,
               org.name as crisis_center,
               CONCAT(user.firstName, ". ", left(user.lastName, 1)) as specialist_name,
               CONVERT_TZ(c.addedtoQueue, '+0:00', '-4:00') as queue_enter,
               CONVERT_TZ(c.takenFromQueue, '+0:00', '-4:00') as queue_exit,
               CONVERT_TZ(c.startTime, '+0:00', '-4:00') as conv_start,
               CONVERT_TZ(c.endTime, '+0:00', '-4:00') as conv_end,
               CONVERT_TZ(minmax.min, '+0:00', '-4:00') as first_seen,
               CONVERT_TZ(minmax.max, '+0:00', '-4:00') as last_seen,
"""

for n in values:
       sql += "sv"+str(n)+".value as "+values[n]+", "

sql += """
               c.conversation_rating as conv_rating,
               c.conversation_feedback_description as conv_rating_desc,
               c.engaged as engaged,
               cf.flag_ID = 'phone_number_requested' as "phone_number_requested",
               c.lastMessage_id as last_message_id
from conversation c
               join actor a on a.id=c.owner_id
               left join survey s on s.conversation_id=c.id
               join user on user.actor_id=c.owner_id
               join org on org.id=user.org_id
               left join note n on n.conversation_id=c.id
               left join conversation_flag cf on cf.conversation_id=c.id
               left join survey on survey.conversation_id=c.id
               left join qi_form on qi_form.conversation_id=c.id
               left join qi_form_value qi7 on qi7.form_id=qi_form.id AND qi7.field_id=7
               join actor_conversations ac on ac.conversation_id=c.id
join actor ta on ta.id=ac.actor_id and ta.type != 'Internal'
join (select actor_id as id, min(timestamp) as min, max(timestamp) as max from message join actor on actor_id=actor.id and actor.type != 'Internal' group by conversation_id) minmax on minmax.id=ta.id
"""

for n in values:
       sql += "left join survey_value sv"+str(n)+" on sv"+str(n)+".survey_id=survey.id AND sv"+str(n)+".question_id="+str(n)+" "

sql += """WHERE
              c.conversation_rating IS NOT NULL
              AND org.id != 12
              AND org.id != 1
              AND org.id != 2
              AND c.engaged = 1
              AND TIMEDIFF(CONVERT_TZ(c.endTime, '+0:00', '-4:00'), CONVERT_TZ(c.takenFromQueue, '+0:00', '-4:00')) < 36000
              AND TIMEDIFF(CONVERT_TZ(c.endTime, '+0:00', '-4:00'), CONVERT_TZ(c.takenFromQueue, '+0:00', '-4:00')) > 0"""

sql += " group by c.id;"



rowindexes = range(11,22)
# Execute the query
print "Running query"
cursor.execute(sql)

# Process a column
def clean(value):
       if not isinstance(value, basestring):
           return value
        
       # Find all occurrences of quotes and get just their contents
       value = re.findall(r'"(.*?)"', value)
       # Convert the list to a comma-separated string
       value = ','.join(value)
       return value

# Get the results of the query
results = cursor.fetchall()
columns = cursor.description

columns = [x[0] for x in columns]

print "Writing CSV"
# Open a CSV
with open('elva_conversation_level.csv', 'wb') as csvfile:
       # Create a CSV writer
       writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

       writer.writerow(columns)
       # Loop over the results from the DB
       for row in results:
               # Convert a tuple to a list
               row = list(row)
               # If the column is not NULL
               for idx in rowindexes:
                       if row[idx] is not None:
                               row[idx] = clean(row[idx])

               # Write to the CSV
               writer.writerow(row)

db.close()

print "done"
