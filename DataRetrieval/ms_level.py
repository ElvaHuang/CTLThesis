#!/usr/bin/python

import MySQLdb
import MySQLdb.cursors
import csv
import re

# Open database connection
db = MySQLdb.connect('192.168.6.2', 'elva', '1207hry0111Njy', 'ctl', cursorclass=MySQLdb.cursors.SSCursor)

# Create a cursor
cursor = db.cursor()

# Here's the SQL statement
sql = """ SELECT m.id as m_id,
                 m.conversation_id as c_id,
                 m.actor_id as a_id,
                 REPLACE(m.message, '\0', "") as message,
                 a.type as actor_type,
                 if (a.type != 'Internal', left(a.address,3), 'NA') as area_code,
                 CONVERT_TZ(m.timestamp, '+0:00', '-4:00') as m_time
        from message m
                 join actor a on a.id = m.actor_id
                 join conversation c on c.id = m.conversation_id
                 join user ON user.actor_id = c.owner_id
                 join org ON org.id = user.org_id
        WHERE
             c.conversation_rating IS NOT NULL
             AND org.id != 12
             AND org.id != 1
             AND org.id != 2
             AND c.engaged = 1
             AND TIMEDIFF(CONVERT_TZ(c.endTime, '+0:00', '-4:00'), CONVERT_TZ(c.takenFromQueue, '+0:00', '-4:00')) < 36000
             AND TIMEDIFF(CONVERT_TZ(c.endTime, '+0:00', '-4:00'), CONVERT_TZ(c.takenFromQueue, '+0:00', '-4:00')) > 0
"""

rowindexes = range(4,5)
# Execute the query
print "Running Query"
cursor.execute(sql)

# Get the results of the query
columns = cursor.description
columns =[x[0] for x in columns]

# Process a column
print "Cleaning Data"
def clean(value):
        # Find all occurrences of quotes and get just their contents
        value = re.findall(r'"(.*?)"', value)
        # Convert the list to a comma-separated string
        value = ','.join(value)
        return value


# Open a CSV
print "Writing CSV"
with open('elva_message_level.csv', 'wb') as csvfile:
        # Create a CSV writer
        writer = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

        # Loop over the results from the DB
        for row in cursor:
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
