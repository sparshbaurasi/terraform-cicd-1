{
    "Version": "2012-10-17",
    "Id": "Policy1663932958150",
    "Statement": [
        {
            "Sid": "Stmt1663932952921",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${bucket_name}"
        }
    ]
}