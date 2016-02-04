//
//  CallAdressbookViewController.m
//  Project17
//
//  Created by fighter on 15/12/22.
//  Copyright © 2015年 Facebook. All rights reserved.
//

#import "CallAdressbookViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
@class CallAdressbookViewController;

@interface CallAdressbookViewController ()<ABPeoplePickerNavigationControllerDelegate>

@end

@implementation CallAdressbookViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  
  ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
  peoplePicker.peoplePickerDelegate = self;
  
  [self presentViewController:peoplePicker animated:YES completion:nil];

  
  [self authoriy];
  
}

- (void)authoriy{
  //    1.授权注册
  
  if (&ABAddressBookRequestAccessWithCompletion != NULL) {//检查是否是iOS6
    //iOS6版本中
    ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
      //如果从未申请过权限，申请权限
      ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error) {
        //根据granted参数判断用户是否同意授予权限、
        if (granted) {
          //查询所有，即显示通讯录所有联系人
          [self getContacts];
        }
      });
    }else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
      //如果权限已经被授予，查询所有，即显示通讯录所有联系人
      [self getContacts];
    }else{
      //如果权限被收回，提醒用户去系统设置菜单中打开
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置>通用>访问权限" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil, nil];
      [alert show];
      return;
    }
    if (abRef) {
      CFRelease(abRef);
    }
  }
}

- (void)getContacts{
  //获取全部通讯录单元信息
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
  //1.取全部联系人
  CFArrayRef allPerson = ABAddressBookCopyArrayOfAllPeople(addressBook);
  CFIndex number = ABAddressBookGetPersonCount(addressBook);
  //进行遍历
  for (NSInteger i = 0; i < number; i ++) {
    ABRecordRef people = CFArrayGetValueAtIndex(allPerson, i);
    //2.获取联系人的姓名
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
    NSString *middleName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
    NSString *nameString  = nil;
		if (firstName.length != 0) nameString = firstName;
  if (middleName.length != 0) nameString = [nameString stringByAppendingString:middleName];
  if (lastName.length != 0) nameString = [nameString stringByAppendingString:lastName];
    //         if (firstName.length == 0 || lastName.length == 0) nameString = firstName ? [NSString stringWithFormat:@"%@%@" , firstName(lastName ? lastName : @"") ] : @"";
//    nameString = middleName.length ?  [NSString stringWithFormat:@"%@%@%@", lastName, middleName, firstName] : [NSString stringWithFormat:@"%@%@", lastName, firstName];
    NSLog(@"姓名：%@", nameString);
    
    //3.获取联系人的头像图片
    //        NSData *userImageData = (__bridge NSData *)(ABPersonCopyImageData(people));
    //        UIImage *userImage = [UIImage imageWithData:userImageData];
    //        NSData *data = UIImageJPEGRepresentation(userImage, 1.0);
    //        NSString *userImageString= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //        NSURL *userImageURL  = [NSURL URLWithString:userImageString];
    //        NSLog(@"头像：%@", userImageURL);
    
    //4.获取联系人电话
    ABMutableMultiValueRef phoneMutil = ABRecordCopyValue(people, kABPersonPhoneProperty);
    NSMutableArray *phones = [[NSMutableArray alloc] init];
    for (int  i = 0; i < ABMultiValueGetCount(phoneMutil); i ++) {
      //            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneMutil, i));
      NSString *phoneLabel = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(phoneMutil, i));
      //            if (phone.length  <  11) {
      //                break;
      //            }
      if ([phoneLabel isEqualToString:@"_$!<Mobile>!$_"]) {
        [phones addObject:(__bridge id _Nonnull)(ABMultiValueCopyValueAtIndex(phoneMutil, i))];
      }else{
        [phones addObject:(__bridge id _Nonnull)(ABMultiValueCopyValueAtIndex(phoneMutil, i))];
      }
    }
    for (int  i = 0; i < phones.count; i ++) {
      NSLog(@"电话%d：%@", i+1, phones[i]);
    }
  }
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
  ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
  CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef, identifier);
  CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, index);
  
  
////  获取联系人姓名
//  ABRecordRef people = CFArrayGetValueAtIndex(valuesRef, index);
//  NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
//  NSString *middleName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
//  NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
//  NSString *nameString  = nil;
//  if (firstName.length != 0) nameString = firstName;
//  if (middleName.length != 0) nameString = [nameString stringByAppendingString:middleName];
//  if (lastName.length != 0) nameString = [nameString stringByAppendingString:lastName];
  //         if (firstName.length == 0 || lastName.length == 0) nameString = firstName ? [NSString stringWithFormat:@"%@%@" , firstName(lastName ? lastName : @"") ] : @"";
//  nameString = middleName.length ?  [NSString stringWithFormat:@"%@%@%@", lastName, middleName, firstName] : [NSString stringWithFormat:@"%@%@", lastName, firstName];
	
	CFStringRef anFullName = ABRecordCopyCompositeName(person);
	
	
  [peoplePicker dismissViewControllerAnimated:YES completion:^{
    [self dismissViewControllerAnimated:YES completion:^{
      self.contactPhoneNumber =  (__bridge NSString *)(value);
          self.contactName = (__bridge NSString *)(anFullName);

      
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Num" object:self.contactPhoneNumber userInfo: @{@"name" : self.contactName}];
      
      NSLog(@"%@ %@", self.contactPhoneNumber, self.contactName);
    }];
  }];
  
  
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
  [peoplePicker dismissViewControllerAnimated:YES completion:^{
    //获取联系人姓名
//    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
//    NSString *middleName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
//    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
//    NSString *nameString  = nil;
//		if (firstName.length != 0) nameString = firstName;
//  if (middleName.length != 0) nameString = [nameString stringByAppendingString:middleName];
//  if (lastName.length != 0) nameString = [nameString stringByAppendingString:lastName];
    //         if (firstName.length == 0 || lastName.length == 0) nameString = firstName ? [NSString stringWithFormat:@"%@%@" , firstName(lastName ? lastName : @"") ] : @"";
//    nameString = middleName.length ?  [NSString stringWithFormat:@"%@%@%@", lastName, middleName, firstName] : [NSString stringWithFormat:@"%@%@", lastName, firstName];
		
		CFStringRef anFullName = ABRecordCopyCompositeName(person);
		
    [self dismissViewControllerAnimated:YES completion:^{
      ABMultiValueRef phones = ABRecordCopyValue(person,kABPersonPhoneProperty);
      NSString *phone  = nil;
      for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
        phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, i));
        NSLog(@"telephone = %@",phone);
      }
      self.contactPhoneNumber = phone;
           self.contactName = (__bridge NSString *)(anFullName);

      
		[[NSNotificationCenter defaultCenter] postNotificationName:@"Num" object:self.contactPhoneNumber userInfo: @{@"name" : self.contactName}];
		
		NSLog(@"%@ %@", self.contactPhoneNumber, self.contactName);
    }];
      }];
  return YES;
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self dismissViewControllerAnimated:YES completion:^{
      [self dismissViewControllerAnimated:YES completion:nil];
    }];
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
