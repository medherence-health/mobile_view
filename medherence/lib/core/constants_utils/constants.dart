import 'package:flutter/material.dart';

InputDecoration kFormTextDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      (10),
    ),
    borderSide: BorderSide(
      width: (2),
      color: Colors.grey.shade500,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      (10),
    ),
    borderSide: const BorderSide(
      width: (2),
      color: Colors.black87,
    ),
  ),
);

InputDecoration kProfileInputDecoration = InputDecoration(
  filled: true,
  // fillColor: Colors.white70,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      (10),
    ),
    borderSide: const BorderSide(
      width: (2),
      color: Colors.black87,
    ),
  ),
);
