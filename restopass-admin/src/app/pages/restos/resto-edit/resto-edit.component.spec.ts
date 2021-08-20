import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RestoEditComponent } from './resto-edit.component';

describe('RestoEditComponent', () => {
  let component: RestoEditComponent;
  let fixture: ComponentFixture<RestoEditComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RestoEditComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RestoEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
