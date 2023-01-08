import 'dart:typed_data';

import 'package:flutter_contacts/properties/address.dart';
import 'package:flutter_contacts/properties/email.dart';
import 'package:flutter_contacts/properties/event.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:flutter_contacts/properties/social_media.dart';
import 'package:flutter_contacts/properties/website.dart';

class Contact {
  String? id;
  String? displayName;
  Uint8List? photo;
  Uint8List? thumbnail;
  Name? name;
  List<Phone>? phones;
  List<Email>? emails;
  List<Address>? addresses;
  List<Organization>? organizations;
  List<Website>? websites;
  List<SocialMedia>? socialMedias;
  List<Event>? events;
  List<Note>? notes;
  List<Group>? groups;
}
class Name { String? first; String? last; }
class Phone { String? number; PhoneLabel? label; }
class Email { String? address; EmailLabel? label; }
class Address { String? address; AddressLabel? label; }
class Organization { String? company; String? title; }
class Website { String? url; WebsiteLabel? label; }
class SocialMedia { String? userName; SocialMediaLabel? label; }
class Event { int? year; int? month; int? day; EventLabel? label; }
class Note { String? note; }
class Group { String? id; String? name; }