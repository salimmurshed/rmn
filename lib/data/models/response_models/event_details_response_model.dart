import 'package:flutter/material.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

class EventDetailsResponseModel {
  EventDetailsResponseModel({
    this.status,
    this.responseData,
  });

  EventDetailsResponseModel.fromJson(dynamic json) {
    status = json['status'];
    responseData = json['responseData'] != null
        ? EventResponseData.fromJson(json['responseData'])
        : null;
  }

  bool? status;
  EventResponseData? responseData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (responseData != null) {
      map['responseData'] = responseData?.toJson();
    }
    return map;
  }
}

class EventResponseData {
  EventResponseData({
    this.message,
    this.assetsUrl,
    this.event,
    this.weightInGuidelines,
  });

  EventResponseData.fromJson(dynamic json) {
    message = json['message'];
    assetsUrl = json['assets_url'];
    event = json['event'] != null ? EventData.fromJson(json['event']) : null;
    weightInGuidelines = json['weight_in_guidelines'] != null
        ? WeightInGuidelines.fromJson(json['weight_in_guidelines'])
        : null;
  }

  String? message;
  String? assetsUrl;
  EventData? event;
  WeightInGuidelines? weightInGuidelines;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['assets_url'] = assetsUrl;
    if (event != null) {
      map['event'] = event?.toJson();
    }
    if (weightInGuidelines != null) {
      map['weight_in_guidelines'] = weightInGuidelines?.toJson();
    }
    return map;
  }
}

class WeightInGuidelines {
  WeightInGuidelines({
    this.displayOptions,
    this.pageTitle,
    this.pageName,
    this.pageType,
    this.description,
    this.pageContent,
    this.id,
    this.version,
    this.createdAt,
    this.updatedAt,
  });

  WeightInGuidelines.fromJson(dynamic json) {
    displayOptions = json['display_options'] != null
        ? DisplayOptions.fromJson(json['display_options'])
        : null;
    pageTitle = json['page_title'];
    pageName = json['page_name'];
    pageType = json['page_type'];
    description = json['description'];
    pageContent = json['page_content'];
    id = json['_id'];
    version = json['version'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  DisplayOptions? displayOptions;
  String? pageTitle;
  String? pageName;
  String? pageType;
  String? description;
  dynamic pageContent;
  String? id;
  num? version;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (displayOptions != null) {
      map['display_options'] = displayOptions?.toJson();
    }
    map['page_title'] = pageTitle;
    map['page_name'] = pageName;
    map['page_type'] = pageType;
    map['description'] = description;
    map['page_content'] = pageContent;
    map['_id'] = id;
    map['version'] = version;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class DisplayOptions {
  DisplayOptions({
    this.mainMenu,
    this.subMenu,
  });

  DisplayOptions.fromJson(dynamic json) {
    mainMenu = json['main_menu'];
    subMenu = json['sub_menu'];
  }

  bool? mainMenu;
  bool? subMenu;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['main_menu'] = mainMenu;
    map['sub_menu'] = subMenu;
    return map;
  }
}

class Venue {
  Venue({
    this.name,
    this.image,
    this.video,
  });

  Venue.fromJson(dynamic json) {
    name = json['name'];
    image = json['image'];
    video = json['video'];
  }

  String? name;
  String? image;
  String? video;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['image'] = image;
    map['video'] = video;
    return map;
  }
}

class EventData {
  EventData({
    this.id,
    this.slug,
    this.shortDesc,
    this.coverImage,
    this.mainImage,
    this.bannerImage,
    this.startTime,
    this.scheduleOverview,
    this.divisionGuidelines,
    this.timezone,
    this.season,
    this.guestRegistrationPrice,
    this.wrestlingType,
    this.isSpecialEvent,
    this.liveStreamUrl,
    this.isDisabled,
    this.isRegistrationAvailable,
    this.coordinates,
    this.address,
    this.city,
    this.createdAt,
    this.endDatetime,
    this.pincode,
    this.startDatetime,
    this.state,
    this.title,
    this.updatedAt,
    this.guestRegistrationPrices,
    this.isArchived,
    this.links,
    this.registrations,
    this.registrationTab,
    this.hotels,
    this.schedules,
    this.products,
    this.divisions,
    this.additionalData,
    this.description,
    this.awards,
    this.underscoreId,
    this.unreadCount,
    this.chatRoomId,
    this.divisionTypes,
    this.cutoffDate,
    this.athleteProfiles,
    this.eventInDays,
    this.eventStatus,
    this.registrationLink,
    this.isRegistrationExternal,
    this.venue,
    this.hotelsDescription,
    // this.sentNotifications,
    this.youtubeVideo,
    this.eventRegistrationLimit,
    this.totalRegistrations,
    this.hasGradeBrackets,
    this.temporeryLimit
    //this.registrationLimitations,
  });

  EventData.fromJson(dynamic json) {
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
    registrationTab = json['registration_tab'] != null
        ? RegistrationTab.fromJson(json['registration_tab'])
        : null;
    slug = json['slug'];
    shortDesc = json['short_desc'];
    coverImage = json['cover_image'];
    mainImage = json['main_image'];
    bannerImage = json['banner_image'];
    startTime = json['start_time'];
    if (json['hotels'] != null) {
      hotels = [];
      json['hotels'].forEach((v) {
        hotels?.add(Hotels.fromJson(v));
      });
    }
    scheduleOverview = json['schedule_overview'];
    if (json['schedules'] != null) {
      schedules = [];
      json['schedules'].forEach((v) {
        schedules?.add(Schedules.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    divisionGuidelines = json['division_guidelines'];
    timezone = json['timezone'];
    if (json['divisions'] != null) {
      divisions = [];
      json['divisions'].forEach((v) {
        divisions?.add(Divisions.fromJson(v));
      });
    }
    season = json['season'] != null ? Season.fromJson(json['season']) : null;
    guestRegistrationPrice = json['guest_registration_price'];
    wrestlingType = json['wrestling_type'];
    isSpecialEvent = json['is_special_event'];
    liveStreamUrl = json['live_stream_url'];
    if (json['additional_data'] != null) {
      additionalData = [];
      json['additional_data'].forEach((v) {
        additionalData?.add(AdditionalData.fromJson(v));
      });
    }
    // if (json['sent_notifications'] != null) {
    //   sentNotifications = [];
    //   json['sent_notifications'].forEach((v) {
    //     sentNotifications?.add(Dynamic.fromJson(v));
    //   });
    // }
    isDisabled = json['is_disabled'];
    eventInDays = json['eventInDays'];
    eventStatus = json['eventStatus'];
    isRegistrationAvailable = json['is_registration_available'];
    isArchived = json['is_archived'];
    underscoreId = json['_id'];
    youtubeVideo = json['youtube_video'];
    address = json['address'];
    city = json['city'];
    createdAt = json['createdAt'];
    endDatetime = json['end_datetime'];
    pincode = json['pincode'];
    startDatetime = json['start_datetime'];
    state = json['state'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    description = json['description'];
    athleteProfiles = json['athleteProfiles'];
    eventRegistrationLimit = json['event_registration_limit'];
    totalRegistrations = json['total_registrations'];
    if (json['awards'] != null) {
      awards = [];
      json['awards'].forEach((v) {
        awards?.add(Award.fromJson(v));
      });
    }
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    if (json['guest_registration_prices'] != null) {
      guestRegistrationPrices = [];
      json['guest_registration_prices'].forEach((v) {
        guestRegistrationPrices?.add(GuestRegistrationPrices.fromJson(v));
      });
    }
    id = json['_id'];
    employees =
        json['employees'] != null ? json['employees'].cast<String>() : [];
    isBookmarked = json['is_bookmarked'];
    unreadCount = json['unread_count'];
    chatRoomId = json['chat_room_id'];
    registrationLink = json["registration_link"];
    isRegistrationExternal = json["is_registration_external"];
    hasGradeBrackets = json["has_grade_brackets"];
    venue = json['venue'] != null ? Venue.fromJson(json['venue']) : null;
    if (json['registrations'] != null) {
      registrations = [];
      json['registrations'].forEach((v) {
        registrations?.add(Registrations.fromJson(v));
      });
    }
    if (json['division_types'] != null) {
      divisionTypes = [];
      json['division_types'].forEach((v) {
        divisionTypes?.add(DivisionTypes.fromJson(v));
      });
    }
    cutoffDate = json['cutoff_date'];
    hotelsDescription = json['hotels_description'];
    temporeryLimit = json['temporeryLimit'];
  }

  Coordinates? coordinates;
  num? temporeryLimit;
  RegistrationTab? registrationTab;
  String? slug;
  String? shortDesc;
  String? coverImage;
  String? mainImage;
  String? bannerImage;
  String? startTime;
  List<Hotels>? hotels;
  String? scheduleOverview;
  List<Schedules>? schedules;
  List<Products>? products;
  String? divisionGuidelines;
  String? timezone;
  List<Divisions>? divisions;
  Season? season;
  EventStatus? eventStatus;
  List<String>? employees;
  bool? isBookmarked;
  String? eventInDays;
  num? guestRegistrationPrice;
  dynamic wrestlingType;
  bool? isSpecialEvent;
  dynamic liveStreamUrl;
  List<AdditionalData>? additionalData;
  bool? isDisabled;
  bool? isRegistrationAvailable;
  bool? isArchived;
  String? id;
  String? address;
  String? city;
  String? createdAt;
  String? endDatetime;
  String? pincode;
  String? startDatetime;
  String? state;
  String? title;
  String? updatedAt;
  String? description;
  List<Award>? awards;
  List<GuestRegistrationPrices>? guestRegistrationPrices;
  String? underscoreId;
  num? unreadCount;
  String? chatRoomId;
  Links? links;
  List<Registrations>? registrations;
  List<DivisionTypes>? divisionTypes;
  String? cutoffDate;
  List<String>? athleteProfiles;
  String? registrationLink;
  bool? isRegistrationExternal;
  Venue? venue;
  dynamic hotelsDescription;
  String? youtubeVideo;
  num? eventRegistrationLimit;
  num? totalRegistrations;
  bool? hasGradeBrackets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (coordinates != null) {
      map['coordinates'] = coordinates?.toJson();
    }

    if (registrationTab != null) {
      map['registration_tab'] = registrationTab?.toJson();
    }
    map['slug'] = slug;
    map['temporeryLimit'] = temporeryLimit;
    map['short_desc'] = shortDesc;
    map['cover_image'] = coverImage;
    map['main_image'] = mainImage;
    map['banner_image'] = bannerImage;
    map['start_time'] = startTime;
    map['venue'] = venue?.toJson();
    map['is_bookmarked'] = isBookmarked;
    map['employees'] = employees;
    map['youtube_video'] = youtubeVideo;
    map['event_registration_limit'] = eventRegistrationLimit;
    map['has_grade_brackets'] = hasGradeBrackets;
    if (hotels != null) {
      map['hotels'] = hotels?.map((v) => v.toJson()).toList();
    }
    map['schedule_overview'] = scheduleOverview;
    if (schedules != null) {
      map['schedules'] = schedules?.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products?.map((v) => v.toJson()).toList();
    }
    map['division_guidelines'] = divisionGuidelines;
    map['timezone'] = timezone;
    if (divisions != null) {
      map['divisions'] = divisions?.map((v) => v.toJson()).toList();
    }
    if (season != null) {
      map['season'] = season?.toJson();
    }
    map['guest_registration_price'] = guestRegistrationPrice;
    map["registration_link"] = registrationLink;
    map["is_registration_external"] = isRegistrationExternal;
    map['wrestling_type'] = wrestlingType;
    map['is_special_event'] = isSpecialEvent;
    map['live_stream_url'] = liveStreamUrl;
    map['eventStatus'] = eventStatus;
    map['eventInDays'] = eventInDays;
    if (additionalData != null) {
      map['additional_data'] = additionalData?.map((v) => v.toJson()).toList();
    }
    // if (sentNotifications != null) {
    //   map['sent_notifications'] =
    //       sentNotifications?.map((v) => v.toJson()).toList();
    // }
    map['is_disabled'] = isDisabled;
    map['is_registration_available'] = isRegistrationAvailable;
    map['is_archived'] = isArchived;
    map['_id'] = underscoreId;
    map['address'] = address;
    map['city'] = city;
    map['createdAt'] = createdAt;
    map['end_datetime'] = endDatetime;
    map['pincode'] = pincode;
    map['start_datetime'] = startDatetime;
    map['state'] = state;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    map['athleteProfiles'] = athleteProfiles;
    map['description'] = description;
    if (awards != null) {
      map['awards'] = awards?.map((v) => v.toJson()).toList();
    }
    if (guestRegistrationPrices != null) {
      map['guest_registration_prices'] =
          guestRegistrationPrices?.map((v) => v.toJson()).toList();
    }
    map['_id'] = id;
    map['unread_count'] = unreadCount;
    map['chat_room_id'] = chatRoomId;
    if (links != null) {
      map['links'] = links?.toJson();
    }
    if (registrations != null) {
      map['registrations'] = registrations?.map((v) => v.toJson()).toList();
    }
    if (divisionTypes != null) {
      map['division_types'] = divisionTypes?.map((v) => v.toJson()).toList();
    }
    map['cutoff_date'] = cutoffDate;
    map['hotels_description'] = hotelsDescription;
    return map;
  }
}

class Hotels {
  Hotels({
    this.coordinates,
    this.description,
    this.email,
    this.linkText,
    this.image,
    this.id,
    this.title,
    this.contactNumber,
    this.address,
    this.link,
    this.createdAt,
    this.updatedAt,
  });

  Coordinates? coordinates;
  String? description;
  String? email;
  dynamic linkText;
  String? image;
  String? id;
  String? title;
  String? contactNumber;
  String? address;
  String? link;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Hotels.fromJson(Map<String, dynamic> json) => Hotels(
        coordinates: json["coordinates"] == null
            ? null
            : Coordinates.fromJson(json["coordinates"]),
        description: json["description"],
        email: json["email"],
        linkText: json["link_text"],
        image: json["image"],
        id: json["_id"],
        title: json["title"],
        contactNumber: json["contact_number"],
        address: json["address"],
        link: json["link"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "location": coordinates?.toJson(),
        "description": description,
        "email": email,
        "link_text": linkText,
        "image": image,
        "_id": id,
        "title": title,
        "contact_number": contactNumber,
        "address": address,
        "link": link,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class DivisionTypes {
  DivisionTypes({
    this.divisionType,
    this.ageGroups,
    this.isExpanded,
    this.numberOfSelectedRegisteredAthlete,
  });

  DivisionTypes.fromJson(dynamic json) {
    divisionType = json['division_type'];
    numberOfSelectedRegisteredAthlete =
        json['numberOfSelectedRegisteredAthlete'];
    isExpanded = json['isExpanded'];
    if (json['age_groups'] != null) {
      ageGroups = [];
      json['age_groups'].forEach((v) {
        ageGroups?.add(AgeGroups.fromJson(v));
      });
    }
  }

  String? divisionType;
  List<AgeGroups>? ageGroups;
  bool? isExpanded;
  int? numberOfSelectedRegisteredAthlete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['division_type'] = divisionType;
    map['numberOfSelectedRegisteredAthlete'] =
        numberOfSelectedRegisteredAthlete;
    map['isExpanded'] = isExpanded;
    if (ageGroups != null) {
      map['age_groups'] = ageGroups?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AgeGroups {
  AgeGroups({
    this.title,
    this.isExpanded,
    this.ageGroupWithWeightsJoined,
    this.ageGroupWithExpansionPanelWeights,
    this.weightAvailable,
    this.maxDate,
    this.minAge,
    this.maxAge,
    this.athletes,
    this.expansionPanelAthlete,
    this.registeredAthletes,
    this.availableAthletes,
    this.selectedAthletes,
    this.registeredWeights,
    this.selectedAthletesForCount,
    this.registeredAthletesForCount,
    this.styles,
    this.grade,
    this.minGrade,
    this.maxGrade,
    this.needUpdate
  });

  AgeGroups.fromJson(dynamic json) {
    title = json['title'];
    grade = json['grade'];
    minGrade = json['min_grade'];
    maxGrade = json['max_grade'];
    grade = json['grade'];
    isExpanded = json['isExpanded'];
    ageGroupWithWeightsJoined = json['ageGroupWithWeightsJoined'];
    ageGroupWithExpansionPanelWeights =
        json['ageGroupWithExpansionPanelWeights'];
    weightAvailable = json['weightAvailable'];
    registeredWeights = json['registeredWeights'];
    maxDate = json['max_date'];
    minAge = json['min_age'];
    needUpdate = json['needUpdate'];
    maxAge = json['max_age'];
    if (json['athletes'] != null) {
      athletes = [];
      json['athletes'].forEach((v) {
        athletes?.add(Athlete.fromJson(v));
      });
    }
    if (json['expansionPanelAthlete'] != null) {
      expansionPanelAthlete = [];
      json['expansionPanelAthlete'].forEach((v) {
        expansionPanelAthlete?.add(Athlete.fromJson(v));
      });
    }
    if (json['registeredAthletes'] != null) {
      registeredAthletes = [];
      json['registeredAthletes'].forEach((v) {
        registeredAthletes?.add(Athlete.fromJson(v));
      });
    }
    if (json['availableAthletes'] != null) {
      availableAthletes = [];
      json['availableAthletes'].forEach((v) {
        availableAthletes?.add(Athlete.fromJson(v));
      });
    }
    if (json['selectedAthletes'] != null) {
      selectedAthletes = [];
      json['selectedAthletes'].forEach((v) {
        selectedAthletes?.add(Athlete.fromJson(v));
      });
    }
    if (json['selectedAthletesForCount'] != null) {
      selectedAthletesForCount = [];
      json['selectedAthletes'].forEach((v) {
        selectedAthletesForCount?.add(Athlete.fromJson(v));
      });
    }
    if (json['registeredAthletesForCount'] != null) {
      registeredAthletesForCount = [];
      json['registeredAthletesForCount'].forEach((v) {
        registeredAthletesForCount?.add(Athlete.fromJson(v));
      });
    } else {
      registeredAthletesForCount = [];
    }
    if (json['distributedAthletes'] != null) {
      distributedAthletes = [];
      json['selectedAthletes'].forEach((v) {
        distributedAthletes?.add(Athlete.fromJson(v));
      });
    }
    if (json['styles'] != null) {
      styles = [];
      json['styles'].forEach((v) {
        styles?.add(Styles.fromJson(v));
      });
    }
  }

  String? title;
  String? grade;
  String? maxDate;
  String? ageGroupWithWeightsJoined;
  List<String>? ageGroupWithExpansionPanelWeights;
  List<String>? weightAvailable;
  List<String>? registeredWeights;
  num? minAge;
  num? maxAge;
  bool? needUpdate;
  String? minGrade;
  String? maxGrade;
  List<Athlete>? athletes;
  List<Athlete>? expansionPanelAthlete;
  List<Athlete>? distributedAthletes;
  List<Athlete>? availableAthletes;
  List<Athlete>? registeredAthletes;
  List<Athlete>? selectedAthletes;
  List<Athlete>? selectedAthletesForCount;
  List<Athlete>? registeredAthletesForCount;
  List<Styles>? styles;
  bool? isExpanded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['grade'] = grade;
    map['min_grade'] = minGrade;
    map['max_grade'] = maxGrade;
    map['isExpanded'] = isExpanded;
    map['needUpdate'] = needUpdate;
    map['ageGroupWithWeightsJoined'] = ageGroupWithWeightsJoined;

    map['ageGroupWithExpansionPanelWeights'] =
        ageGroupWithExpansionPanelWeights;
    map['weightAvailable'] = weightAvailable;
    map['registeredWeights'] = registeredWeights;
    map['max_date'] = maxDate;
    map['min_age'] = minAge;
    map['max_age'] = maxAge;
    if (athletes != null) {
      map['athletes'] = athletes?.map((v) => v.toJson()).toList();
    }
    if (expansionPanelAthlete != null) {
      map['expansionPanelAthlete'] =
          expansionPanelAthlete?.map((v) => v.toJson()).toList();
    }
    if (registeredAthletes != null) {
      map['registeredAthletes'] =
          registeredAthletes?.map((v) => v.toJson()).toList();
    }
    if (distributedAthletes != null) {
      map['distributedAthletes'] =
          distributedAthletes?.map((v) => v.toJson()).toList();
    }
    if (availableAthletes != null) {
      map['availableAthletes'] =
          availableAthletes?.map((v) => v.toJson()).toList();
    }
    if (selectedAthletes != null) {
      map['selectedAthletes'] =
          selectedAthletes?.map((v) => v.toJson()).toList();
    }
    if (selectedAthletesForCount != null) {
      map['selectedAthletesForCount'] =
          selectedAthletesForCount?.map((v) => v.toJson()).toList();
    }
    if (registeredAthletesForCount != null) {
      map['registeredAthletesForCount'] =
          registeredAthletesForCount?.map((v) => v.toJson()).toList();
    } else {
      map['registeredAthletesForCount'] = [];
    }
    if (styles != null) {
      map['styles'] = styles?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Styles {
  Styles({
    this.id,
    this.divisionType,
    this.style,
    this.division,
    this.registeredWeights,
    this.temporarilySelectedWeights,
    this.registeredWeightClasses,
    this.temporarySelectedWeightClasses,
    this.finalizedSelectedWeightClasses,
    this.finalizedSelectedWeights,
    this.registeredAthletes,
    this.disclaimer,
    this.isCalculated,
    this.ageGroup,
  });

  Styles.fromJson(dynamic json) {
    id = json['_id'];
    divisionType = json['division_type'];
    disclaimer = json['disclaimer'];
    style = json['style'];
    ageGroup = json['ageGroup'];
    registeredWeightClasses = json['registeredWeightClasses'];
    temporarySelectedWeightClasses = json['selectedWeightClasses'];
    temporarilySelectedWeights = json['selectedWeights'];
    registeredWeights = json['registeredWeights'];
    if (json['registered_athletes'] != null) {
      registeredAthletes = [];
      json['registered_athletes'].forEach((v) {
        registeredAthletes?.add(RegisteredAthletes.fromJson(v));
      });
    }
    division =
        json['division'] != null ? Division.fromJson(json['division']) : null;
  }

  String? id;
  String? divisionType;
  String? style;
  String? ageGroup;
  String? disclaimer;
  Division? division;
  List<WeightClass>? registeredWeightClasses;
  List<WeightClass>? temporarySelectedWeightClasses;
  List<WeightClass>? finalizedSelectedWeightClasses;
  List<String>? temporarilySelectedWeights;
  List<String>? finalizedSelectedWeights;
  List<String>? registeredWeights;
  List<RegisteredAthletes>? registeredAthletes;
  bool? isCalculated;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['division_type'] = divisionType;
    map['disclaimer'] = disclaimer;

    map['style'] = style;
    map['ageGroup'] = ageGroup;
    if (division != null) {
      map['division'] = division?.toJson();
    }

    if (registeredAthletes != null) {
      map['registered_athletes'] =
          registeredAthletes?.map((v) => v.toJson()).toList();
    }
    if (registeredWeightClasses != null) {
      map['registeredWeightClasses'] =
          registeredWeightClasses?.map((v) => v.toJson()).toList();
    }
    if (temporarySelectedWeightClasses != null) {
      map['selectedWeightClasses'] =
          temporarySelectedWeightClasses?.map((v) => v.toJson()).toList();
    }
    if (finalizedSelectedWeightClasses != null) {
      map['finalizedSelectedWeightClasses'] =
          finalizedSelectedWeightClasses?.map((v) => v.toJson()).toList();
    }
    if (temporarilySelectedWeights != null) {
      map['selectedWeights'] = temporarilySelectedWeights;
    }
    if (registeredWeights != null) {
      map['selectedWeights'] = registeredWeights;
    }
    if (finalizedSelectedWeights != null) {
      map['finalizedSelectedWeights'] = finalizedSelectedWeights;
    }

    return map;
  }
}

class RegisteredAthletes {
  RegisteredAthletes({
    this.teamId,
    this.qrCodeImage,
    this.price,
    this.isSeasonPassRegistration,
    this.id,
    this.userId,
    this.eventId,
    this.athleteId,
    this.eventDivisionId,
    this.divisionId,
    this.orderNo,
    this.weightClassId,
    this.createdAt,
    this.updatedAt,
    this.ownershipTransferred,
    this.team,
    this.athletes,
  });

  RegisteredAthletes.fromJson(dynamic json) {
    teamId = json['team_id'];
    qrCodeImage = json['qr_code_image'];
    price = json['price'];
    isSeasonPassRegistration = json['is_season_pass_registration'];
    userId = json['user_id'];
    eventId = json['event_id'];
    athleteId = json['athlete_id'];
    eventDivisionId = json['event_division_id'];
    divisionId = json['division_id'];
    orderNo = json['order_no'];
    weightClassId = json['weight_class_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ownershipTransferred = json['ownership_transferred'];
    id = json['id'];
    team = json['team'] != null ? Team.fromJson(json['team']) : null;
    athletes =
        json['athletes'] != null ? Athlete.fromJson(json['athletes']) : null;
  }

  String? teamId;
  dynamic qrCodeImage;
  num? price;
  bool? isSeasonPassRegistration;
  String? id;
  String? userId;
  String? eventId;
  String? athleteId;
  String? eventDivisionId;
  String? divisionId;
  String? orderNo;
  String? weightClassId;
  String? createdAt;
  String? updatedAt;
  bool? ownershipTransferred;
  Team? team;
  Athlete? athletes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['team_id'] = teamId;
    map['qr_code_image'] = qrCodeImage;
    map['price'] = price;
    map['is_season_pass_registration'] = isSeasonPassRegistration;
    map['user_id'] = userId;
    map['event_id'] = eventId;
    map['athlete_id'] = athleteId;
    map['event_division_id'] = eventDivisionId;
    map['division_id'] = divisionId;
    map['order_no'] = orderNo;
    map['weight_class_id'] = weightClassId;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['ownership_transferred'] = ownershipTransferred;
    map['id'] = id;
    if (team != null) {
      map['team'] = team?.toJson();
    }
    if (athletes != null) {
      map['athletes'] = athletes?.toJson();
    }
    return map;
  }
}

class AdditionalData {
  AdditionalData({
    this.id,
    this.content,
    this.createdAt,
    this.eventId,
    this.title,
    this.updatedAt,
  });

  AdditionalData.fromJson(dynamic json) {
    id = json['_id'];
    content = json['content'];
    createdAt = json['createdAt'];
    eventId = json['event_id'];
    title = json['title'];
    updatedAt = json['updatedAt'];
  }

  String? id;
  String? content;
  String? createdAt;
  String? eventId;
  String? title;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['content'] = content;
    map['createdAt'] = createdAt;
    map['event_id'] = eventId;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class Season {
  Season({
    this.id,
    this.createdAt,
    this.endDate,
    this.startDate,
    this.title,
    this.updatedAt,
    this.isCurrent,
    this.underscoreId,
  });

  Season.fromJson(dynamic json) {
    underscoreId = json['_id'];
    createdAt = json['createdAt'];
    endDate = json['end_date'];
    startDate = json['start_date'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    isCurrent = json['is_current'];
    id = json['id'];
  }

  String? id;
  String? createdAt;
  String? endDate;
  String? startDate;
  String? title;
  String? updatedAt;
  bool? isCurrent;
  String? underscoreId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['end_date'] = endDate;
    map['start_date'] = startDate;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    map['is_current'] = isCurrent;
    map['id'] = id;
    return map;
  }
}

class Divisions {
  Divisions({
    this.parentDivisions,
    this.style,
    this.id,
    this.createdAt,
    this.divisionType,
    this.eventId,
    this.updatedAt,
  });

  Divisions.fromJson(dynamic json) {
    if (json['parent_divisions'] != null) {
      parentDivisions = [];
      json['parent_divisions'].forEach((v) {
        parentDivisions?.add(ParentDivisions.fromJson(v));
      });
    }
    style = json['style'];
    id = json['_id'];
    createdAt = json['createdAt'];
    divisionType = json['division_type'];
    eventId = json['event_id'];
    updatedAt = json['updatedAt'];
  }

  List<ParentDivisions>? parentDivisions;
  String? style;
  String? id;
  String? createdAt;
  String? divisionType;
  String? eventId;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (parentDivisions != null) {
      map['parent_divisions'] =
          parentDivisions?.map((v) => v.toJson()).toList();
    }

    map['style'] = style;
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['division_type'] = divisionType;
    map['event_id'] = eventId;
    map['updatedAt'] = updatedAt;
    return map;
  }
}

class ParentDivisions {
  ParentDivisions({
    this.style,
    this.weightClasses,
    this.id,
    this.createdAt,
    this.divisionType,
    this.maxAge,
    this.minAge,
    this.seasonId,
    this.title,
    this.updatedAt,
    this.maxDate,
    this.athletes,
  });

  ParentDivisions.fromJson(dynamic json) {
    style = json['style'];
    if (json['weight_classes'] != null) {
      weightClasses = [];
      json['weight_classes'].forEach((v) {
        weightClasses?.add(WeightClass.fromJson(v));
      });
    }
    id = json['_id'];
    createdAt = json['createdAt'];
    divisionType = json['division_type'];
    maxAge = json['max_age'];
    minAge = json['min_age'];
    seasonId = json['season_id'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    maxDate = json['max_date'];
    if (json['athletes'] != null) {
      athletes = [];
      json['athletes'].forEach((v) {
        athletes?.add(Athlete.fromJson(v));
      });
    }
  }

  String? style;
  List<WeightClass>? weightClasses;
  String? id;
  String? createdAt;
  String? divisionType;
  num? maxAge;
  num? minAge;
  String? seasonId;
  String? title;
  String? updatedAt;
  String? maxDate;
  List<Athlete>? athletes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['style'] = style;
    if (weightClasses != null) {
      map['weight_classes'] = weightClasses?.map((v) => v.toJson()).toList();
    }
    map['_id'] = id;
    map['createdAt'] = createdAt;
    map['division_type'] = divisionType;
    map['max_age'] = maxAge;
    map['min_age'] = minAge;
    map['season_id'] = seasonId;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    map['max_date'] = maxDate;
    if (athletes != null) {
      map['athletes'] = athletes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Products {
  Products({
    this.variants,
    this.id,
    this.isOpen,
    this.eventId,
    this.updatedAt,
    this.createdAt,
    this.endDate,
    this.price,
    this.productDetails,
    this.underscoreId,
    this.selectedVariant,
    this.quantity,
    this.totalPrice,
    this.restrictions,
    this.category,
    this.isGiveaway,
    this.externalUrl,
    this.image,
    this.qrProductTitle,
    this.seasonId,
    this.isAddedToCart,
    this.purchasedVariant,
    this.isGiveawayAdded,
    this.giveAwayCounts,
    this.availableGiveaways,
    this.isMaxGiveawayAdded,
  });

  Products.fromJson(dynamic json) {
    restrictions = json['restrictions'] != null
        ? Restrictions.fromJson(json['restrictions'])
        : null;

    category = json['category'];
    availableGiveaways = json['available_giveaways'];
    isOpen = json['isOpen'];
    isGiveaway = json['is_giveaway'];
    giveAwayCounts = json['giveAwayCounts'];
    externalUrl = json['external_url'];
    image = json['image'];
    qrProductTitle = json['title'];
    if (json['variants'] != null) {
      variants = [];
      json['variants'].forEach((v) {
        variants?.add(v);
      });
    }
    underscoreId = json['_id'];
    selectedVariant = json['selectedVariant'];
    eventId = json['event_id'];
    createdAt = json['createdAt'];
    endDate = json['end_date'];
    price = json['price'];
    isAddedToCart = json['isAddedToCart'];
    dropDownKeyForProduct = json['dropDownKeyForProduct'];
    totalPrice = json['totalPrice'];
    productType = json['productType'];
    quantity = json['quantity'];
    updatedAt = json['updatedAt'];
    productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
    id = json['id'];
    image = json['image'];
    seasonId = json['season_id'];
    purchasedVariant = json['variant'];
    isGiveawayAdded = json['isGiveawayAdded'];
    isMaxGiveawayAdded = json['isMaxGiveawayAdded'];
  }

  List<String>? variants;
  bool? isGiveawayAdded;
  bool? isMaxGiveawayAdded;
  int? availableGiveaways;
  String? id;
  String? purchasedVariant;
  String? eventId;
  String? createdAt;
  String? endDate;
  num? price;
  int? giveAwayCounts;
  num? quantity;
  num? totalPrice;
  String? updatedAt;
  ProductDetails? productDetails;
  String? underscoreId;
  String? selectedVariant;
  String? productType;
  String? image;
  Restrictions? restrictions;
  String? category;
  bool? isGiveaway;
  bool? isOpen;
  bool? isAddedToCart;
  String? externalUrl;
  String? seasonId;
  String? qrProductTitle;
  GlobalKey<State<StatefulWidget>>? dropDownKeyForProduct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (variants != null) {
      map['variants'] = variants;
    }
    map['_id'] = underscoreId;
    map['giveAwayCounts'] = giveAwayCounts;
    map['isGiveawayAdded'] = isGiveawayAdded;
    map['isMaxGiveawayAdded'] = isMaxGiveawayAdded;
    map['available_giveaways'] = availableGiveaways;
    map['variant'] = purchasedVariant;
    map['image'] = image;
    map['isOpen'] = isOpen;
    map['isAddedToCart'] = isAddedToCart;
    map['season_id'] = seasonId;

    map['restrictions'] = restrictions;

    map['category'] = category;
    map['is_giveaway'] = isGiveaway;
    map['external_url'] = externalUrl;
    map['title'] = qrProductTitle;
    map['selectedVariant'] = selectedVariant;
    map['productType'] = productType;
    map['event_id'] = eventId;
    map['createdAt'] = createdAt;
    map['end_date'] = endDate;
    map['price'] = price;
    map['totalPrice'] = totalPrice;
    map['quantity'] = quantity;
    map['updatedAt'] = updatedAt;
    map['dropDownKeyForProduct'] = dropDownKeyForProduct;
    if (productDetails != null) {
      map['product_details'] = productDetails?.toJson();
    }
    map['id'] = id;
    return map;
  }
}

class ProductDetails {
  ProductDetails({
    this.description,
    this.isGiveaway,
    this.image,
    this.title,
    this.id,
    this.giveAwayType,
    this.isGiveawayMandatory,
  });

  ProductDetails.fromJson(dynamic json) {
    description = json['description'];
    isGiveaway = json['is_giveaway'];
    image = json['image'];
    title = json['title'];
    giveAwayType = json['giveaway_type'];
    isGiveawayMandatory = json['is_giveaway_mandatory'];
    id = json['_id'];
  }

  String? description;
  bool? isGiveaway;
  bool? isGiveawayMandatory;
  String? image;
  String? title;
  String? id;
  String? giveAwayType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['is_giveaway'] = isGiveaway;
    map['is_giveaway_mandatory'] = isGiveawayMandatory;
    map['giveaway_type'] = giveAwayType;
    map['image'] = image;
    map['title'] = title;
    map['_id'] = id;
    return map;
  }
}

class Schedules {
  Schedules({
    this.endTime,
    this.id,
    this.createdAt,
    this.date,
    this.description,
    this.eventId,
    this.startTime,
    this.title,
    this.updatedAt,
    this.scheduleDatetime,
    this.underscoreId,
    this.isExpanded,
  });

  Schedules.fromJson(dynamic json) {
    endTime = json['end_time'];
    underscoreId = json['_id'];
    createdAt = json['createdAt'];
    date = json['date'];
    description = json['description'];
    eventId = json['event_id'];
    startTime = json['start_time'];
    title = json['title'];
    updatedAt = json['updatedAt'];
    scheduleDatetime = json['schedule_datetime'];
    id = json['id'];
    isExpanded = json['isExpanded'];
  }

  String? endTime;
  String? id;
  String? createdAt;
  String? date;
  String? description;
  String? eventId;
  String? startTime;
  String? title;
  String? updatedAt;
  String? scheduleDatetime;
  String? underscoreId;
  bool? isExpanded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['end_time'] = endTime;
    map['_id'] = underscoreId;
    map['createdAt'] = createdAt;
    map['date'] = date;
    map['description'] = description;
    map['event_id'] = eventId;
    map['start_time'] = startTime;
    map['title'] = title;
    map['updatedAt'] = updatedAt;
    map['schedule_datetime'] = scheduleDatetime;
    map['id'] = id;
    map['isExpanded'] = isExpanded;
    return map;
  }
}

class RegistrationTab {
  RegistrationTab({
    this.schedule,
    this.isAvailable,
    this.title,
    this.description,
  });

  RegistrationTab.fromJson(dynamic json) {
    schedule =
        json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
    isAvailable = json['is_available'];
    title = json['title'];
    description = json['description'];
  }

  Schedule? schedule;
  bool? isAvailable;
  String? title;
  String? description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (schedule != null) {
      map['schedule'] = schedule?.toJson();
    }
    map['is_available'] = isAvailable;
    map['title'] = title;
    map['description'] = description;
    return map;
  }
}

class Schedule {
  Schedule({
    this.startDatetime,
    this.endDatetime,
  });

  Schedule.fromJson(dynamic json) {
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
  }

  dynamic startDatetime;
  dynamic endDatetime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start_datetime'] = startDatetime;
    map['end_datetime'] = endDatetime;
    return map;
  }
}
